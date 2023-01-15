import 'dart:convert';

import 'package:html/parser.dart';
import 'package:http/http.dart';

Future<void> main(List<String> args) async {
  final channelHandle = args.first;
  final response = await get(Uri.https("youtube.com", "@$channelHandle"));
  final document = parse(response.body);

  const jsPrefix = "var ytInitialData = ";
  final js = document
      .querySelectorAll("script")
      .map((e) => e.text)
      .firstWhere((e) => e.startsWith(jsPrefix));

  final json = js.substring(jsPrefix.length, js.length - 1);
  final object = jsonDecode(json);
  final channelId = object["metadata"]["channelMetadataRenderer"]["externalId"];
  print(channelId);
}
