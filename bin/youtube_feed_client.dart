import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';

import 'model/video.dart';

part 'youtube_feed_client.g.dart';

class YouTubeFeedClient {
  final Client _http;
  final String _apiKey;

  YouTubeFeedClient(this._apiKey) : _http = Client();

  Future<Set<Video>> getVideos(String channelId) async {
    final url = Uri.https(
      "youtube.com",
      "/feeds/videos.xml",
      {"channel_id": channelId},
    );
    final response = await _http.get(url);
    final xml = response.body;
    final document = XmlDocument.parse(xml);
    final entries = document.findAllElements("entry");
    return entries.map(Video.fromXml).toSet();
  }

  Future<ListPlaylistItemsResponse> getPlaylistItems(String playlistId) async {
    final url = Uri.https(
      "youtube.googleapis.com",
      "/youtube/v3/playlistItems",
      {
        "part": "snippet",
        "playlistId": playlistId,
        "key": _apiKey,
      },
    );
    final response = await _http.get(
      url,
      headers: {"Authorization": "Bearer $_apiKey"},
    );
    final json = response.body;
    final object = jsonDecode(json);
    return ListPlaylistItemsResponse.fromJson(object);
  }
}

@JsonSerializable()
class ListPlaylistItemsResponse {
  final String? kind;
  final String? etag;
  // final String? nextPageToken;
  // final String? prevPageToken;
  // final PageInfo? pageInfo;
  final List<PlaylistItem> items;

  const ListPlaylistItemsResponse({
    this.kind,
    this.etag,
    // this.nextPageToken,
    // this.prevPageToken,
    // this.pageInfo,
    required this.items,
  });

  factory ListPlaylistItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$ListPlaylistItemsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListPlaylistItemsResponseToJson(this);
}

@JsonSerializable()
class PlaylistItem {
  final String kind;
  // final String etag;
  final String id;
  final Snippet snippet;
  // final ContentDetails? contentDetails;
  // final Status? status;

  const PlaylistItem({
    required this.kind,
    // this.etag,
    required this.id,
    required this.snippet,
    // this.contentDetails,
    // this.status,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistItemFromJson(json);

  Map<String, dynamic> toJson() => _$PlaylistItemToJson(this);
}

@JsonSerializable()
class Snippet {
  final DateTime publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final String playlistId;
  final int position;
  final ResourceId resourceId;

  const Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.playlistId,
    required this.position,
    required this.resourceId,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) =>
      _$SnippetFromJson(json);

  Map<String, dynamic> toJson() => _$SnippetToJson(this);
}

@JsonSerializable()
class Thumbnails {
  final Thumbnail defaultThumbnail;
  final Thumbnail medium;
  final Thumbnail high;
  final Thumbnail standard;
  final Thumbnail maxres;

  const Thumbnails({
    required this.defaultThumbnail,
    required this.medium,
    required this.high,
    required this.standard,
    required this.maxres,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailsFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);
}

@JsonSerializable()
class Thumbnail {
  final String url;
  final int width;
  final int height;

  const Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}

@JsonSerializable()
class ResourceId {
  final String kind;
  final String videoId;

  const ResourceId(this.kind, this.videoId);

  factory ResourceId.fromJson(Map<String, dynamic> json) =>
      _$ResourceIdFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceIdToJson(this);
}
