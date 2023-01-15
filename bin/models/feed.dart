import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable()
class Feed {
  final String name;

  final String slug;

  final Set<String> channels;

  Feed(this.name, String? slug, this.channels)
      : slug = slug ?? name.toLowerCase().replaceAll(' ', '-');

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);
}
