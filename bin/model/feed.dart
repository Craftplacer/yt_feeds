import 'package:json_annotation/json_annotation.dart';

part 'feed.g.dart';

@JsonSerializable(
  explicitToJson: true,
  converters: [FeedChannelJsonConverter()],
)
class Feed {
  final String name;

  final String slug;

  final Set<FeedChannel> channels;

  Feed(this.name, String? slug, this.channels)
      : slug = slug ?? name.toLowerCase().replaceAll(' ', '-');

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);

  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

class FeedChannel {
  final String handle;
  final String id;

  FeedChannel(this.handle, this.id);

  factory FeedChannel.fromJson(String value) {
    final split = value.split(':');
    return FeedChannel(split[0], split[1]);
  }

  String toJson() => '$handle:$id';
}

class FeedChannelJsonConverter extends JsonConverter<FeedChannel, String> {
  const FeedChannelJsonConverter();

  @override
  FeedChannel fromJson(String json) => FeedChannel.fromJson(json);

  @override
  String toJson(FeedChannel object) => object.toJson();
}
