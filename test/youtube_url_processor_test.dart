import 'package:flutter_test/flutter_test.dart';

import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  group('YouTubeUrlExtractor', () {
    const extractor = YouTubeUrlExtractor();

    test('extracts from youtu.be short URL', () {
      final r = extractor.extract('https://youtu.be/dQw4w9WgXcQ?t=43');
      expect(r.isSuccess, true);
      final e = r.value!;
      expect(e.type, YouTubeContentType.video);
      expect(e.video!.videoId, 'dQw4w9WgXcQ');
      expect(e.video!.startAt?.inSeconds, 43);
    });

    test('extracts from watch URL with playlist context', () {
      final r = extractor.extract(
        'https://www.youtube.com/watch?v=dQw4w9WgXcQ&list=PL1234567890ABCDEF&index=5',
      );
      expect(r.isSuccess, true);
      final e = r.value!;
      expect(e.type, YouTubeContentType.video);
      expect(e.video!.videoId, 'dQw4w9WgXcQ');
      expect(e.video!.playlistId, 'PL1234567890ABCDEF');
      expect(e.video!.playlistIndex, 5);
    });

    test('detects shorts URL', () {
      final r = extractor.extract('https://www.youtube.com/shorts/5qap5aO4i9A');
      expect(r.isSuccess, true);
      final e = r.value!;
      expect(e.type, YouTubeContentType.short);
      expect(e.video!.isShort, true);
      expect(e.video!.videoId, '5qap5aO4i9A');
    });

    test('extracts playlist by id', () {
      final r = extractor.extract(
        'https://www.youtube.com/playlist?list=RDMMabcdEFG1234',
      );
      expect(r.isSuccess, true);
      final e = r.value!;
      expect(e.type, YouTubeContentType.playlist);
      expect(e.playlist!.playlistId, 'RDMMabcdEFG1234');
      expect(e.playlist!.isMix, true);
    });

    test('extracts channel handle', () {
      final r = extractor.extract('https://www.youtube.com/@somehandle');
      expect(r.isSuccess, true);
      final e = r.value!;
      expect(e.type, YouTubeContentType.channel);
      expect(e.channel!.handle, '@somehandle');
    });

    test('unknown for non-YouTube domains', () {
      final r = extractor.extract('https://example.com');
      expect(r.isSuccess, false);
    });
  });

  group('YouTubeThumbnails', () {
    test('builds hq thumbnail url', () {
      final u = YouTubeThumbnails.url('dQw4w9WgXcQ');
      expect(u.toString(), 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg');
    });

    test('builds webp maxres thumbnail url', () {
      final u = YouTubeThumbnails.url(
        'dQw4w9WgXcQ',
        quality: YouTubeThumbnailQuality.maxres,
        webp: true,
      );
      expect(
        u.toString(),
        'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.webp',
      );
    });
  });

  group('Embed URL builder', () {
    test('builds embed url with options', () {
      final u = buildEmbedUri(
        'dQw4w9WgXcQ',
        options: YouTubeEmbedOptions(
          autoplay: true,
          controls: false,
          modestBranding: true,
          rel: false,
          enableJsApi: true,
          mute: true,
        ),
        privacyEnhanced: true,
      );
      expect(u.host, 'www.youtube-nocookie.com');
      expect(u.path, '/embed/dQw4w9WgXcQ');
      expect(u.queryParameters['autoplay'], '1');
      expect(u.queryParameters['controls'], '0');
      expect(u.queryParameters['enablejsapi'], '1');
      expect(u.queryParameters['mute'], '1');
    });

    test('builds iframe html', () {
      final html = buildIframeHtml(
        'dQw4w9WgXcQ',
        options: YouTubeEmbedOptions(autoplay: true),
        privacyEnhanced: true,
        width: 640,
        height: 360,
      );
      expect(html.contains('iframe'), true);
      expect(html.contains('www.youtube-nocookie.com'), true);
      expect(html.contains('autoplay=1'), true);
      expect(html.contains('width="640"'), true);
      expect(html.contains('height="360"'), true);
    });
  });
}
