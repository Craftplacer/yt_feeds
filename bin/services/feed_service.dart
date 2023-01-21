import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../cached_value.dart';
import '../model/feed.dart';
import '../model/video.dart';
import '../youtube_feed_client.dart';

part 'feed_service.g.dart';

class FeedService {
  final Map<String, List<Feed>> localizedFeeds;
  final String defaultLanguage;
  final YouTubeFeedClient youtubeClient;
  final Template template;

  late final Map<String, CachedValue<Set<Video>>> _cachedChannels;
  late final Map<String, CachedValue<Set<Video>>> _cachedPlaylists;
  final _viewsNumberFormat = NumberFormat("#,###");

  Router get router => _$FeedServiceRouter(this);

  FeedService({
    required this.localizedFeeds,
    required this.template,
    this.defaultLanguage = "en",
    required this.youtubeClient,
  }) {
    final channels = localizedFeeds.values.flattened
        .map((e) => e.channels)
        .flattened
        .map((e) => e)
        .toSet();

    _cachedChannels = {
      for (final channel in channels)
        channel.id: CachedValue(
          () => youtubeClient.getVideos(channel.id),
          const Duration(hours: 3),
        ),
    };
  }

  @Route.get('/')
  Future<Response> viewDefaultFeed(Request req) async {
    final language = defaultLanguage;
    final feed = localizedFeeds[language]?.first;

    if (feed == null) {
      return Response.internalServerError(
        body: "No feed for default language $language",
      );
    }

    return Response.movedPermanently("/$language/${feed.slug}");
  }

  @Route.get('/<language>/<feed>')
  Future<Response> viewFeed(Request req) async {
    final language = req.params["language"]!;
    final slug = req.params["feed"]!;

    final feed =
        localizedFeeds[language]?.firstWhereOrNull((e) => e.slug == slug);
    if (feed == null) {
      return Response.notFound("Feed not found");
    }

    return _renderFeed(feed, language);
  }

  Future<Response> _renderFeed(Feed feed, String language) async {
    final feeds = localizedFeeds[language]!;
    final Map<String, Set<Video>> videos;

    try {
      final list = await Future.wait(
        _cachedChannels.entries.map(
          (e) async => MapEntry(e.key, await e.value.fetch()),
        ),
      );
      videos = Map.fromEntries(list);
    } catch (e, s) {
      return Response(HttpStatus.badGateway, body: "$e\n$s");
    }

    final rendered = template.renderString(<String, dynamic>{
      "feeds": feeds
          .map(
            (e) => {
              ...e.toJson(),
              "selected": feed.slug == e.slug,
              "href": "/$language/${e.slug}"
            },
          )
          .toList(),
      "videoFeed": feed.channels
          .map((e) => videos[e.id]!)
          .flattened
          .sorted((a, b) => b.uploadedAt.compareTo(a.uploadedAt))
          .groupListsBy(
            (e) => TimePeriod.fromDuration(
              DateTime.now().difference(e.uploadedAt),
            ),
          )
          .entries
          .map(
            (kv) => {
              'header': kv.key.toString(),
              'videos': kv.value.map((e) {
                return e.toJson()
                  ..["views"] = _viewsNumberFormat.format(e.views)
                  ..["ago"] = Jiffy(e.uploadedAt).fromNow();
              }),
            },
          ),
      "currentFeed": {
        ...feed.toJson(),
        "channels": feed.channels.map(
          (e) {
            return {
              "handle": e.handle,
              "url": "https://www.youtube.com/channel/${e.id}",
            };
          },
        ).toList(),
      },
      "currentLanguage": language.toUpperCase(),
      "languages": localizedFeeds.keys.map((e) => e.toUpperCase()),
      "feedStateJson": jsonEncode(
        Map.fromEntries(
          feeds.map(
            (e) => MapEntry(
              e.slug,
              e.channels
                  .map((e) => videos[e.id]!)
                  .flattened
                  .sorted((a, b) => b.uploadedAt.compareTo(a.uploadedAt))
                  .first
                  .uploadedAt
                  .toIso8601String(),
            ),
          ),
        ),
      ),
    });

    return Response.ok(
      rendered,
      headers: {"Content-Type": "text/html; charset=utf-8"},
    );
  }
}

enum TimePeriod {
  today,
  yesterday,
  thisWeek,
  thisMonth,
  thisYear,
  longAgo;

  factory TimePeriod.fromDuration(Duration duration) {
    if (duration.inDays <= 0) {
      return TimePeriod.today;
    } else if (duration.inDays == 1) {
      return TimePeriod.yesterday;
    } else if (duration.inDays <= 7) {
      return TimePeriod.thisWeek;
    } else if (duration.inDays <= 30) {
      return TimePeriod.thisMonth;
    } else if (duration.inDays <= 365) {
      return TimePeriod.thisYear;
    } else {
      return TimePeriod.longAgo;
    }
  }

  @override
  String toString() {
    switch (this) {
      case TimePeriod.today:
        return "Today";
      case TimePeriod.yesterday:
        return "Yesterday";
      case TimePeriod.thisWeek:
        return "This Week";
      case TimePeriod.thisMonth:
        return "This Month";
      case TimePeriod.thisYear:
        return "This Year";
      case TimePeriod.longAgo:
        return "A Long Time Ago";
    }
  }
}

// class FeedContext {
//   final Set<String> languages;
//   final String currentLanguage;
//
//   Map<String, dynamic> toJson() {
//     return {};
//   }
// }
