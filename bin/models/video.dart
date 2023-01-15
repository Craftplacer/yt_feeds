import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';

import 'channel.dart';

part 'video.g.dart';

@JsonSerializable(explicitToJson: true)
class Video {
  final String id;
  final String title;
  final Uri url;
  final Uri thumbnailUrl;
  final DateTime uploadedAt;
  final int views;
  final Channel channel;

  const Video({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.views,
    required this.uploadedAt,
    required this.channel,
  });

  factory Video.fromXml(XmlElement e) {
    final mediaGroup = e.getElement("media:group")!;
    final mediaCommunity = mediaGroup.getElement("media:community")!;
    final author = e.getElement("author")!;
    return Video(
      id: e.getElement("yt:videoId")!.text,
      title: e.getElement("title")!.text,
      url: Uri.parse(e
          .findElements("link")
          .firstWhere((e) => e.getAttribute("rel") == "alternate")
          .getAttribute("href")!),
      thumbnailUrl: Uri.parse(
        mediaGroup.getElement("media:thumbnail")!.getAttribute("url")!,
      ),
      views: int.parse(
        mediaCommunity.getElement("media:statistics")!.getAttribute("views")!,
      ),
      uploadedAt: DateTime.parse(
        e.getElement("published")!.text,
      ),
      channel: Channel(
        Uri.parse(author.getElement("uri")!.text),
        author.getElement("name")!.text,
      ),
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}
