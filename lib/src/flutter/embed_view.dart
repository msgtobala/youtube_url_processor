import 'package:flutter/widgets.dart';

import '../embed.dart';

typedef YouTubeWebViewBuilder = Widget Function(
    BuildContext context, Uri embedUri, String iframeHtml);

class YouTubeEmbedView extends StatelessWidget {
  final String videoId;
  final YouTubeEmbedOptions options;
  final bool privacyEnhanced;
  final YouTubeWebViewBuilder builder;

  const YouTubeEmbedView({
    super.key,
    required this.videoId,
    required this.builder,
    this.options = const YouTubeEmbedOptions(),
    this.privacyEnhanced = false,
  });

  @override
  Widget build(BuildContext context) {
    final uri = buildEmbedUri(
      videoId,
      options: options,
      privacyEnhanced: privacyEnhanced,
    );
    final html = buildIframeHtml(
      videoId,
      options: options,
      privacyEnhanced: privacyEnhanced,
    );
    return builder(context, uri, html);
  }
}
