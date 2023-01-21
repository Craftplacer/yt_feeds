import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mustache_template/mustache_template.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:path/path.dart' as path;

import 'model/feed.dart';
import 'services/feed_service.dart';
import 'youtube_feed_client.dart';

final _staticHandler = createStaticHandler("assets");
void main(List<String> args) async {
  final feeds = await loadFeeds();

  final templateHtml = await File("feed.html").readAsString();
  final template = Template(templateHtml);

  final youtubeApiKey = Platform.environment['YOUTUBE_API_KEY'];

  if (youtubeApiKey == null) {
    print("YOUTUBE_API_KEY environment variable is not set");
    exit(1);
  }

  final youtubeClient = YouTubeFeedClient(youtubeApiKey);

  final feedService = FeedService(
    localizedFeeds: feeds,
    template: template,
    youtubeClient: youtubeClient,
  );

  final cascade = Cascade().add(feedService.router).add(_staticHandler);
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(cascade.handler);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await serve(handler, ip, port);

  final uri = Uri(scheme: 'http', host: server.address.host, port: server.port);
  print('Server listening at $uri');
}

Future<Map<String, List<Feed>>> loadFeeds() async {
  final feeds = <String, List<Feed>>{};

  await for (final entity in Directory("feeds").list()) {
    if (entity is! File) continue;

    final extension = path.extension(entity.path).toLowerCase();
    if (extension != ".json") continue;

    final json = await entity.readAsString();
    final list = (jsonDecode(json) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Feed.fromJson)
        .sortedBy((e) => e.slug)
        .toList();

    final name = path.basenameWithoutExtension(entity.path).toLowerCase();
    feeds[name] = list;
  }

  return feeds;
}
