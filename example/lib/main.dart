import 'package:flutter/material.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube URL Processor Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController(
    text: 'https://youtu.be/dQw4w9WgXcQ?t=43',
  );

  ExtractedEntity? _entity;

  void _extract() {
    const extractor = YouTubeUrlExtractor();
    final r = extractor.extract(_controller.text);
    setState(() => _entity = r.value);
  }

  @override
  Widget build(BuildContext context) {
    final videoId = _entity?.video?.videoId;
    return Scaffold(
      appBar: AppBar(title: const Text('YouTube URL Processor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Paste a YouTube URL',
              suffixIcon: IconButton(
                onPressed: _extract,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_entity != null) ...[
            Text('Detected: ${_entity!.type}'),
            if (videoId != null) ...[
              const SizedBox(height: 8),
              Text('Video ID: $videoId'),
              const SizedBox(height: 12),
              const Text('Link Preview:'),
              YouTubeLinkPreview(videoId: videoId),
              const SizedBox(height: 12),
              const Text('Thumbnail (maxres):'),
              Image.network(
                YouTubeThumbnails.url(videoId,
                        quality: YouTubeThumbnailQuality.maxres)
                    .toString(),
                height: 180,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
              const Text('Embed builder (URL shown below):'),
              Builder(
                builder: (context) => YouTubeEmbedView(
                  videoId: videoId,
                  privacyEnhanced: true,
                  options: const YouTubeEmbedOptions(autoplay: false),
                  builder: (context, uri, html) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(uri.toString()),
                        const SizedBox(height: 8),
                        const Text('iframe html:'),
                        SelectableText(
                          html,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
