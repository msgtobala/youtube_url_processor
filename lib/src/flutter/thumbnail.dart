import 'package:flutter/widgets.dart';

import '../thumbnails.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoId;
  final YouTubeThumbnailQuality quality;
  final bool webp;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;

  const YouTubeThumbnail({
    super.key,
    required this.videoId,
    this.quality = YouTubeThumbnailQuality.hq,
    this.webp = false,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final uri = YouTubeThumbnails.url(videoId, quality: quality, webp: webp);
    return Image.network(
      uri.toString(),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
      loadingBuilder: loadingBuilder,
    );
  }
}
