import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  testWidgets('YouTubeEmbedView invokes builder with proper URL and HTML', (tester) async {
    Uri? receivedUri;
    String? receivedHtml;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: YouTubeEmbedView(
            videoId: 'dQw4w9WgXcQ',
            privacyEnhanced: true,
            options: const YouTubeEmbedOptions(autoplay: true),
            builder: (context, uri, html) {
              receivedUri = uri;
              receivedHtml = html;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    expect(receivedUri, isNotNull);
    expect(receivedUri!.host, 'www.youtube-nocookie.com');
    expect(receivedUri!.queryParameters['autoplay'], '1');
    expect(receivedHtml, isNotNull);
    expect(receivedHtml!.contains('iframe'), true);
  });
}


