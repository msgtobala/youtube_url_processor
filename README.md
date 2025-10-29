# youtube_url_processor

A Flutter-friendly, one-stop YouTube URL processor. Parse, normalize, build URLs, fetch metadata (oEmbed/OpenGraph and optional YouTube Data API v3), generate thumbnails, and render link previews or embed views.

## Features

- Core parsing and normalization
  - Detect `video | short | live | clip | playlist | channel | unknown`
  - Parse `youtu.be`, `watch`, `shorts`, `embed`, `live`, `playlist`, `channel/@handle/c/vanity/user/legacy`, `youtube-nocookie`, `m.youtube.com`, `music.youtube.com`
  - Extract params: `v`, `list`, `index`, `t`, `start`, `end`
  - Normalize to canonical watch/playlist/channel URLs
- URL builders
  - Build watch, shorts, embed (privacy-enhanced), playlist, and live channel URLs
  - Build timestamped links and playlist-context links
- Thumbnails
  - Compute thumbnail URLs: default, mq, hq, sd, maxres; jpg/webp
  - `YouTubeThumbnail` widget
- Metadata
  - No-API: oEmbed and OpenGraph fallback
  - Optional: YouTube Data API v3 client (videos, playlists, channels, playlist items)
- Flutter widgets
  - `YouTubeLinkPreview` (thumbnail + title + channel)
  - `YouTubeEmbedView` (builder that supplies embed URL/iframe HTML; integrate with your WebView)
- Utilities
  - Sanitize URLs (strip tracking params)
  - Timecode format/parse helpers
  - Playlist helpers, live/shorts inspection

## Install

```yaml
dependencies:
  youtube_url_processor: ^0.1.0
```

## Quick start

```dart
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  const extractor = YouTubeUrlExtractor();
  final result = extractor.extract('https://youtu.be/dQw4w9WgXcQ?t=43');
  if (result.isSuccess && result.value?.video != null) {
    final video = result.value!.video!;
    final canonical = YouTubeUrlNormalizer.canonicalWatchUrl(video);
    print('Canonical: $canonical');
  }
}
```

## Thumbnails

```dart
// URL only
final u = YouTubeThumbnails.url('dQw4w9WgXcQ', quality: YouTubeThumbnailQuality.maxres);

// Flutter widget
YouTubeThumbnail(videoId: 'dQw4w9WgXcQ', quality: YouTubeThumbnailQuality.hq)
```

## Link preview (oEmbed/OpenGraph)

```dart
YouTubeLinkPreview(
  videoId: 'dQw4w9WgXcQ',
  onTap: () {
    // open player or webview
  },
)
```

## Embeds

Use builders to generate embed URLs or iframe HTML, and render with your own WebView package (`webview_flutter` shown below).

```dart
// URL builder
final embedUri = buildEmbedUri(
  'dQw4w9WgXcQ',
  options: const YouTubeEmbedOptions(autoplay: true, controls: false),
  privacyEnhanced: true,
);

// HTML builder
final iframeHtml = buildIframeHtml(
  'dQw4w9WgXcQ',
  options: const YouTubeEmbedOptions(autoplay: true),
  privacyEnhanced: true,
);
```

Or use `YouTubeEmbedView` with a custom builder:

```dart
YouTubeEmbedView(
  videoId: 'dQw4w9WgXcQ',
  privacyEnhanced: true,
  builder: (context, uri, iframe) {
    // Example with webview_flutter_web (web):
    // return HtmlElementView(viewType: ...);
    // Or with webview_flutter (mobile):
    // return WebViewWidget(controller: controller..loadHtmlString(iframe));
    return SizedBox.shrink();
  },
)
```

## Metadata

No-API mode:

```dart
final metaClient = YouTubeMetadataClient();
final r = await metaClient.fetchForVideo('dQw4w9WgXcQ');
print(r.oembed?.title ?? r.openGraph?.title);
```

YouTube Data API v3 (optional):

```dart
final api = YouTubeDataApiV3(apiKey: 'YOUR_API_KEY');
final video = await api.getVideo('dQw4w9WgXcQ');
final playlist = await api.getPlaylist('PL123...');
await for (final item in api.getPlaylistItems('PL123...')) {
  print('${item.index}: ${item.title} (${item.videoId})');
}
```

## Playlists

```dart
final res = await fetchEntirePlaylist(api, 'PL123...');
print('Title: ${res.metadata.title} | Items: ${res.items.length}');
```

## Live/shorts inspection

```dart
final inspector = YouTubeInspector(api: api);
final enriched = await inspector.inspectVideo(const VideoRef(videoId: 'v', isLiveCandidate: true));
print('isLive: ${enriched.isLive}, isUpcoming: ${enriched.isUpcoming}, duration: ${enriched.duration}');
```

## URL sanitation

```dart
final u = Uri.parse('https://www.youtube.com/watch?v=abc&t=30&fbclid=xyz&si=abc');
final s = sanitizeYouTubeUri(u); // keeps v/t, drops tracking
```

## License

MIT
