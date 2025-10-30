import 'dart:convert';

import 'package:http/http.dart' as http;

class OEmbedData {
  final String title;
  final String authorName;
  final String authorUrl;
  final String thumbnailUrl;
  final int thumbnailWidth;
  final int thumbnailHeight;
  final int width;
  final int height;
  final String providerName;

  const OEmbedData({
    required this.title,
    required this.authorName,
    required this.authorUrl,
    required this.thumbnailUrl,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.width,
    required this.height,
    required this.providerName,
  });

  factory OEmbedData.fromJson(Map<String, dynamic> json) => OEmbedData(
        title: json['title'] ?? '',
        authorName: json['author_name'] ?? '',
        authorUrl: json['author_url'] ?? '',
        thumbnailUrl: json['thumbnail_url'] ?? '',
        thumbnailWidth: (json['thumbnail_width'] ?? 0) as int,
        thumbnailHeight: (json['thumbnail_height'] ?? 0) as int,
        width: (json['width'] ?? 0) as int,
        height: (json['height'] ?? 0) as int,
        providerName: json['provider_name'] ?? 'YouTube',
      );
}

class YouTubeOEmbedClient {
  final http.Client _client;

  YouTubeOEmbedClient({http.Client? client})
      : _client = client ?? http.Client();

  Future<OEmbedData> fetch({required Uri url, String? languageCode}) async {
    final qp = <String, String>{'url': url.toString(), 'format': 'json'};
    if (languageCode != null) qp['hl'] = languageCode;
    final uri = Uri.https('www.youtube.com', '/oembed', qp);
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw Exception('oEmbed request failed: ${res.statusCode}');
    }
    final jsonMap = json.decode(res.body) as Map<String, dynamic>;
    return OEmbedData.fromJson(jsonMap);
  }
}
