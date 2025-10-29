import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

class _MockMetadataClientOEmbed extends YouTubeMetadataClient {
  _MockMetadataClientOEmbed();
  @override
  Future<({OEmbedData? oembed, OpenGraphData? openGraph})> fetchForVideo(
      String videoId,
      {String? languageCode}) async {
    return (
      oembed: OEmbedData(
        title: 'OEmbed Title',
        authorName: 'Author',
        authorUrl: '',
        thumbnailUrl: '',
        thumbnailWidth: 0,
        thumbnailHeight: 0,
        width: 0,
        height: 0,
        providerName: 'YouTube',
      ),
      openGraph: null,
    );
  }
}

class _MockMetadataClientOG extends YouTubeMetadataClient {
  _MockMetadataClientOG();
  @override
  Future<({OEmbedData? oembed, OpenGraphData? openGraph})> fetchForVideo(
      String videoId,
      {String? languageCode}) async {
    return (
      oembed: null,
      openGraph: const OpenGraphData(
        title: 'OG Title',
        description: 'Desc',
        imageUrl: '',
        siteName: 'YouTube',
        url: '',
      ),
    );
  }
}

void main() {
  testWidgets('YouTubeLinkPreview shows oEmbed title when available',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YouTubeLinkPreview(
            videoId: 'dQw4w9WgXcQ',
            metadataClient: _MockMetadataClientOEmbed(),
            showThumbnail: false,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('OEmbed Title'), findsOneWidget);
  });

  testWidgets('YouTubeLinkPreview falls back to OpenGraph title',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YouTubeLinkPreview(
            videoId: 'dQw4w9WgXcQ',
            metadataClient: _MockMetadataClientOG(),
            showThumbnail: false,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1));
    expect(find.text('OG Title'), findsOneWidget);
  });
}
