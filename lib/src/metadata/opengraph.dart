import 'package:http/http.dart' as http;

class OpenGraphData {
  final String title;
  final String description;
  final String imageUrl;
  final String siteName;
  final String url;

  const OpenGraphData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.siteName,
    required this.url,
  });
}

class OpenGraphClient {
  final http.Client _client;

  OpenGraphClient({http.Client? client}) : _client = client ?? http.Client();

  Future<OpenGraphData?> fetch(Uri url) async {
    final res = await _client.get(url);
    if (res.statusCode != 200) return null;
    final body = res.body;

    String? meta(String property) {
      final re = RegExp(
          '<meta[^>]+property=["\']$property["\'][^>]+content=["\']([^"\']+)["\']',
          caseSensitive: false);
      final m = re.firstMatch(body);
      return m?.group(1);
    }

    final title = meta('og:title') ?? _extractTitle(body) ?? '';
    final desc = meta('og:description') ?? '';
    final image = meta('og:image') ?? '';
    final site = meta('og:site_name') ?? 'YouTube';
    final canonical = meta('og:url') ?? url.toString();

    return OpenGraphData(
      title: title,
      description: desc,
      imageUrl: image,
      siteName: site,
      url: canonical,
    );
  }

  String? _extractTitle(String html) {
    final re =
        RegExp('<title>(.*?)</title>', caseSensitive: false, dotAll: true);
    final m = re.firstMatch(html);
    return m?.group(1)?.trim();
  }
}
