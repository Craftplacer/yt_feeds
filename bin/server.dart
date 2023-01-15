import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'models/feed.dart';
import 'models/video.dart';
import 'youtube_feed_client.dart';

late final List<Feed> feeds;
late final Template template;

final _ytClient = YouTubeFeedClient();
final _staticHandler = createStaticHandler("assets");
final _router = Router(notFoundHandler: _staticHandler)
  ..get('/', _rootHandler)
  ..get('/<feed>', _feedHandler);

Future<Response> _rootHandler(Request req) async {
  final feed = feeds.first;
  return _renderFeed(feed);
}

Future<Response> _feedHandler(Request req) async {
  final slug = req.params["feed"];
  final feed = feeds.firstWhereOrNull((e) => e.slug == slug);
  if (feed == null) return Response.notFound("Feed not found");
  return _renderFeed(feed);
}

Future<Response> _renderFeed(Feed feed) async {
  final Set<Video> videos;

  try {
    final lists = await Future.wait(
      feed.channels.map(
        (e) => _ytClient.getVideos(e.split(":").last),
      ),
    );
    videos = lists.flattened.toSet();
  } catch (e, s) {
    return Response(HttpStatus.badGateway, body: "$e\n$s");
  }

  final rendered = template.renderString({
    "feeds": feeds
        .map((e) => {...e.toJson(), "selected": feed.slug == e.slug})
        .toList(),
    "videos": videos
        .sorted((a, b) => b.uploadedAt.compareTo(a.uploadedAt))
        .map(
          (e) => e.toJson()
            ..["views"] = NumberFormat("#,###").format(e.views)
            ..["ago"] = Jiffy(e.uploadedAt).fromNow(),
        )
        .toList(),
    "currentFeed": {
      ...feed.toJson(),
      "channels": feed.channels
          .map((e) => e.split(":"))
          .map(
            (e) => {
              "handle": e.first,
              "url": "https://www.youtube.com/channel/${e.last}",
            },
          )
          .toList(),
    },
  });

  return Response.ok(
    rendered,
    headers: {"Content-Type": "text/html; charset=utf-8"},
  );
}

void main(List<String> args) async {
  final feedsJson = await File("feeds.json").readAsString();
  feeds = (jsonDecode(feedsJson) as List<dynamic>)
      .cast<Map<String, dynamic>>()
      .map(Feed.fromJson)
      .sortedBy((e) => e.slug)
      .toList();

  final templateHtml = await File("feed.html").readAsString();
  template = Template(templateHtml);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  final cascade = Cascade().add(_router).add(_staticHandler);
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(cascade.handler);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
