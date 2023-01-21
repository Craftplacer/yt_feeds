// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => Feed(
      json['name'] as String,
      json['slug'] as String?,
      (json['channels'] as List<dynamic>)
          .map((e) => const FeedChannelJsonConverter().fromJson(e as String))
          .toSet(),
    );

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'channels': instance.channels
          .map(const FeedChannelJsonConverter().toJson)
          .toList(),
    };
