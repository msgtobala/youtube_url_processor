import 'dart:core';

import 'utils/timecode.dart';

class YouTubeEmbedOptions {
  final bool autoplay;
  final bool controls;
  final bool modestBranding;
  final bool rel;
  final bool enableJsApi;
  final bool mute;
  final Duration? startAt;
  final Duration? endAt;

  const YouTubeEmbedOptions({
    this.autoplay = false,
    this.controls = true,
    this.modestBranding = true,
    this.rel = false,
    this.enableJsApi = false,
    this.mute = false,
    this.startAt,
    this.endAt,
  });
}

Uri buildEmbedUri(
  String videoId, {
  YouTubeEmbedOptions options = const YouTubeEmbedOptions(),
  bool privacyEnhanced = false,
}) {
  final host = privacyEnhanced ? 'www.youtube-nocookie.com' : 'www.youtube.com';
  final qp = <String, String>{
    'autoplay': options.autoplay ? '1' : '0',
    'controls': options.controls ? '1' : '0',
    'modestbranding': options.modestBranding ? '1' : '0',
    'rel': options.rel ? '1' : '0',
    'enablejsapi': options.enableJsApi ? '1' : '0',
    'mute': options.mute ? '1' : '0',
  };
  if (options.startAt != null) qp['start'] = formatTimecode(options.startAt!);
  if (options.endAt != null) qp['end'] = formatTimecode(options.endAt!);
  return Uri.https(host, '/embed/$videoId', qp);
}

String buildIframeHtml(
  String videoId, {
  YouTubeEmbedOptions options = const YouTubeEmbedOptions(),
  bool privacyEnhanced = false,
  int width = 560,
  int height = 315,
}) {
  final src = buildEmbedUri(
    videoId,
    options: options,
    privacyEnhanced: privacyEnhanced,
  ).toString();
  return '<iframe width="$width" height="$height" src="$src" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>';
}
