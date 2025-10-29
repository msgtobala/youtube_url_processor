import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

void main() {
  const extractor = YouTubeUrlExtractor();

  test('extracts embed url', () {
    final r = extractor.extract('https://www.youtube.com/embed/dQw4w9WgXcQ');
    expect(r.isSuccess, true);
    expect(r.value!.type, YouTubeContentType.video);
    expect(r.value!.video!.videoId, 'dQw4w9WgXcQ');
  });

  test('extracts clip id', () {
    final r = extractor.extract('https://www.youtube.com/clip/AbCdEfGh1234');
    expect(r.isSuccess, true);
    expect(r.value!.type, YouTubeContentType.clip);
  });

  test('handles channel and user and vanity', () {
    final ch = extractor
        .extract('https://www.youtube.com/channel/UC1234567890123456789012');
    expect(ch.isSuccess, true);
    expect(ch.value!.type, YouTubeContentType.channel);

    final handle = extractor.extract('https://www.youtube.com/@flutterdev');
    expect(handle.isSuccess, true);
    expect(handle.value!.channel!.handle, '@flutterdev');

    final vanity = extractor.extract('https://www.youtube.com/c/SomeVanity');
    expect(vanity.isSuccess, true);
    expect(vanity.value!.channel!.vanity, 'SomeVanity');

    final legacy = extractor.extract('https://www.youtube.com/user/legacyUser');
    expect(legacy.isSuccess, true);
    expect(legacy.value!.channel!.legacyUser, 'legacyUser');
  });

  test('handle live endpoints', () {
    final hLive = extractor.extract('https://www.youtube.com/@flutterdev/live');
    expect(hLive.isSuccess, true);
    expect(hLive.value!.type, YouTubeContentType.channel);

    final vLive =
        extractor.extract('https://www.youtube.com/c/SomeVanity/live');
    expect(vLive.isSuccess, true);
    expect(vLive.value!.type, YouTubeContentType.channel);
  });

  test('supports m.youtube.com and music.youtube.com', () {
    final m = extractor.extract('https://m.youtube.com/watch?v=dQw4w9WgXcQ');
    expect(m.isSuccess, true);
    expect(m.value!.video!.videoId, 'dQw4w9WgXcQ');

    final music =
        extractor.extract('https://music.youtube.com/watch?v=dQw4w9WgXcQ');
    expect(music.isSuccess, true);
    expect(music.value!.video!.videoId, 'dQw4w9WgXcQ');
  });

  test('parses start/end time params', () {
    final r = extractor
        .extract('https://www.youtube.com/watch?v=dQw4w9WgXcQ&start=10&end=20');
    expect(r.isSuccess, true);
    expect(r.value!.video!.startAt?.inSeconds, 10);
    expect(r.value!.video!.endAt?.inSeconds, 20);
  });
}
