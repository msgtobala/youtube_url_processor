import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  test('formatTimecode formats hms', () {
    expect(formatTimecode(const Duration(hours: 1, minutes: 2, seconds: 3)),
        '1h2m3s');
    expect(formatTimecode(const Duration(minutes: 2, seconds: 3)), '2m3s');
    expect(formatTimecode(const Duration(seconds: 45)), '45s');
  });

  test('sanitizeYouTubeUri keeps essential params', () {
    final u = Uri.parse(
        'https://www.youtube.com/watch?v=abc123def45&t=30&fbclid=xyz&si=abc');
    final s = sanitizeYouTubeUri(u);
    expect(s.queryParameters.containsKey('v'), true);
    expect(s.queryParameters.containsKey('t'), true);
    expect(s.queryParameters.containsKey('fbclid'), false);
    expect(s.queryParameters.containsKey('si'), false);
  });
}
