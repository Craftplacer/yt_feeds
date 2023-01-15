import 'package:http/http.dart' show Client;
import 'package:xml/xml.dart';

import 'models/video.dart';

class YouTubeFeedClient {
  final Client _http;

  YouTubeFeedClient() : _http = Client();

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
}
