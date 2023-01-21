// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: json['id'] as String,
      title: json['title'] as String,
      url: Uri.parse(json['url'] as String),
      thumbnailUrl: Uri.parse(json['thumbnailUrl'] as String),
      views: json['views'] as int,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      channel: Channel.fromJson(json['channel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url.toString(),
      'thumbnailUrl': instance.thumbnailUrl.toString(),
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'views': instance.views,
      'channel': instance.channel.toJson(),
    };
