class YouTubeProcessorConfig {
  final Duration httpTimeout;
  final String? languageCode;
  final bool enableOEmbed;
  final bool enableOpenGraph;
  final bool followRedirects;
  final bool privacyEnhancedEmbeds;
  final Duration cacheTtl;

  const YouTubeProcessorConfig({
    this.httpTimeout = const Duration(seconds: 10),
    this.languageCode,
    this.enableOEmbed = true,
    this.enableOpenGraph = true,
    this.followRedirects = false,
    this.privacyEnhancedEmbeds = false,
    this.cacheTtl = const Duration(minutes: 30),
  });
}
