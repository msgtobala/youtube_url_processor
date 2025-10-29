import 'package:flutter/material.dart';

import '../metadata/oembed.dart';
import '../metadata/metadata_client.dart';
import '../thumbnails.dart';

class YouTubeLinkPreview extends StatefulWidget {
  final String videoId;
  final void Function()? onTap;
  final YouTubeThumbnailQuality thumbnailQuality;
  final bool thumbnailWebp;
  final EdgeInsetsGeometry padding;
  final double thumbnailAspectRatio;
  final String? languageCode;
  final YouTubeMetadataClient? metadataClient;
  final bool showThumbnail;

  const YouTubeLinkPreview({
    super.key,
    required this.videoId,
    this.onTap,
    this.thumbnailQuality = YouTubeThumbnailQuality.hq,
    this.thumbnailWebp = false,
    this.padding = const EdgeInsets.all(12),
    this.thumbnailAspectRatio = 16 / 9,
    this.languageCode,
    this.metadataClient,
    this.showThumbnail = true,
  });

  @override
  State<YouTubeLinkPreview> createState() => _YouTubeLinkPreviewState();
}

class _YouTubeLinkPreviewState extends State<YouTubeLinkPreview> {
  late final YouTubeMetadataClient _client;
  OEmbedData? _data;
  String? _fallbackTitle;
  String? _fallbackAuthor;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _client = widget.metadataClient ?? YouTubeMetadataClient();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await _client.fetchForVideo(widget.videoId,
          languageCode: widget.languageCode);
      final data = r.oembed;
      if (!mounted) return;
      if (data != null) {
        setState(() => _data = data);
      } else {
        setState(() {
          _fallbackTitle = r.openGraph?.title;
          _fallbackAuthor = r.openGraph?.siteName;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumb = YouTubeThumbnails.url(
      widget.videoId,
      quality: widget.thumbnailQuality,
      webp: widget.thumbnailWebp,
    );

    Widget content;
    if (_error != null) {
      content =
          Text('Failed to load preview', style: theme.textTheme.bodyMedium);
    } else if (_data == null && _fallbackTitle == null) {
      content = const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showThumbnail) ...[
            AspectRatio(
              aspectRatio: widget.thumbnailAspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(thumb.toString(), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            _data?.title ?? _fallbackTitle ?? '',
            style: theme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(_data?.authorName ?? _fallbackAuthor ?? '',
              style: theme.textTheme.bodySmall),
        ],
      );
    }

    final clickable = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: content),
    );

    return Padding(padding: widget.padding, child: clickable);
  }
}
