// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Channel _$ChannelFromJson(Map<String, dynamic> json) => Channel(
      Uri.parse(json['uri'] as String),
      json['name'] as String,
    );

Map<String, dynamic> _$ChannelToJson(Channel instance) => <String, dynamic>{
      'uri': instance.uri.toString(),
      'name': instance.name,
    };
