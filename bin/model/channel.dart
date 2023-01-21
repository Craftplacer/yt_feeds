import 'package:json_annotation/json_annotation.dart';

part 'channel.g.dart';

@JsonSerializable()
class Channel {
  final Uri uri;
  final String name;

  const Channel(this.uri, this.name);

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelToJson(this);
}
