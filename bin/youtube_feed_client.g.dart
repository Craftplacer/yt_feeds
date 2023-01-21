// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_feed_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListPlaylistItemsResponse _$ListPlaylistItemsResponseFromJson(
        Map<String, dynamic> json) =>
    ListPlaylistItemsResponse(
      kind: json['kind'] as String?,
      etag: json['etag'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => PlaylistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListPlaylistItemsResponseToJson(
        ListPlaylistItemsResponse instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'etag': instance.etag,
      'items': instance.items,
    };

PlaylistItem _$PlaylistItemFromJson(Map<String, dynamic> json) => PlaylistItem(
      kind: json['kind'] as String,
      id: json['id'] as String,
      snippet: Snippet.fromJson(json['snippet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaylistItemToJson(PlaylistItem instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'id': instance.id,
      'snippet': instance.snippet,
    };

Snippet _$SnippetFromJson(Map<String, dynamic> json) => Snippet(
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      channelId: json['channelId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnails:
          Thumbnails.fromJson(json['thumbnails'] as Map<String, dynamic>),
      channelTitle: json['channelTitle'] as String,
      playlistId: json['playlistId'] as String,
      position: json['position'] as int,
      resourceId:
          ResourceId.fromJson(json['resourceId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SnippetToJson(Snippet instance) => <String, dynamic>{
      'publishedAt': instance.publishedAt.toIso8601String(),
      'channelId': instance.channelId,
      'title': instance.title,
      'description': instance.description,
      'thumbnails': instance.thumbnails,
      'channelTitle': instance.channelTitle,
      'playlistId': instance.playlistId,
      'position': instance.position,
      'resourceId': instance.resourceId,
    };

Thumbnails _$ThumbnailsFromJson(Map<String, dynamic> json) => Thumbnails(
      defaultThumbnail:
          Thumbnail.fromJson(json['defaultThumbnail'] as Map<String, dynamic>),
      medium: Thumbnail.fromJson(json['medium'] as Map<String, dynamic>),
      high: Thumbnail.fromJson(json['high'] as Map<String, dynamic>),
      standard: Thumbnail.fromJson(json['standard'] as Map<String, dynamic>),
      maxres: Thumbnail.fromJson(json['maxres'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ThumbnailsToJson(Thumbnails instance) =>
    <String, dynamic>{
      'defaultThumbnail': instance.defaultThumbnail,
      'medium': instance.medium,
      'high': instance.high,
      'standard': instance.standard,
      'maxres': instance.maxres,
    };

Thumbnail _$ThumbnailFromJson(Map<String, dynamic> json) => Thumbnail(
      url: json['url'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$ThumbnailToJson(Thumbnail instance) => <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };

ResourceId _$ResourceIdFromJson(Map<String, dynamic> json) => ResourceId(
      json['kind'] as String,
      json['videoId'] as String,
    );

Map<String, dynamic> _$ResourceIdToJson(ResourceId instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'videoId': instance.videoId,
    };
