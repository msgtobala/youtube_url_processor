import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  test('NotConfiguredYouTubeDataApi throws ApiError', () async {
    const api = NotConfiguredYouTubeDataApi();
    expect(() => api.getVideo('abc'), throwsA(isA<ApiError>()));
  });

  test('YouTubeDataApiV3 builds correct videos URI and parses response',
      () async {
    final mock = MockClient((req) async {
      expect(req.url.host, 'www.googleapis.com');
      expect(req.url.path, '/youtube/v3/videos');
      expect(req.url.queryParameters['id'], 'dQw4w9WgXcQ');
      final body = json.encode({
        'items': [
          {
            'id': 'dQw4w9WgXcQ',
            'snippet': {
              'title': 'Test Video',
              'description': 'Desc',
              'channelId': 'UC123',
              'channelTitle': 'Channel',
              'publishedAt': '2020-01-01T00:00:00Z',
              'liveBroadcastContent': 'none',
            },
            'contentDetails': {'duration': 'PT4M5S'},
          }
        ]
      });
      return http.Response(body, 200,
          headers: {'content-type': 'application/json'});
    });
    final client = YouTubeDataApiV3(apiKey: 'x', client: mock);
    final v = await client.getVideo('dQw4w9WgXcQ');
    expect(v.id, 'dQw4w9WgXcQ');
    expect(v.title, 'Test Video');
    expect(v.duration, const Duration(minutes: 4, seconds: 5));
    expect(v.isLive, false);
    expect(v.isUpcoming, false);
  });
}
