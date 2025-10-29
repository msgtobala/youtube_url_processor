import 'package:http/http.dart' as http;

import '../cache/cache.dart';
import '../config.dart';
import '../parsing/normalizer.dart';
import 'oembed.dart';
import 'opengraph.dart';

class YouTubeMetadataClient {
  final YouTubeOEmbedClient _oembed;
  final OpenGraphClient _og;
  final Cache<String, ({OEmbedData? oembed, OpenGraphData? openGraph})>? _cache;
  final YouTubeProcessorConfig _config;

  YouTubeMetadataClient({http.Client? httpClient, Cache<String, ({OEmbedData? oembed, OpenGraphData? openGraph})>? cache, YouTubeProcessorConfig config = const YouTubeProcessorConfig()})
      : _oembed = YouTubeOEmbedClient(client: httpClient),
        _og = OpenGraphClient(client: httpClient),
        _cache = cache,
        _config = config;

  Future<({OEmbedData? oembed, OpenGraphData? openGraph})> fetchForVideo(
    String videoId, {
    String? languageCode,
  }) async {
    final cached = _cache?.get(videoId);
    if (cached != null) return cached;
    final watch = YouTubeUrlNormalizer.watchUrl(videoId: videoId);
    OEmbedData? o;
    if (_config.enableOEmbed) {
      try {
        o = await _oembed.fetch(url: watch, languageCode: languageCode ?? _config.languageCode);
      } catch (_) {}
    }
    OpenGraphData? og;
    if (o == null && _config.enableOpenGraph) {
      og = await _og.fetch(watch);
    }
    final result = (oembed: o, openGraph: og);
    _cache?.set(videoId, result, ttl: _config.cacheTtl);
    return result;
  }
}


