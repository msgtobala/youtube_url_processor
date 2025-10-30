import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

class _ApiLive implements YouTubeDataApi {
  @override
  Future<ChannelMetadata> getChannel(String channelId) async =>
      const ChannelMetadata(id: 'UCx', title: 't', description: 'd');

  @override
  Stream<PlaylistItem> getPlaylistItems(String playlistId,
      {int pageSize = 50}) async* {}

  @override
  Future<PlaylistMetadata> getPlaylist(String playlistId) async =>
      const PlaylistMetadata(id: 'PLx', title: 'Playlist', description: 'Desc');

  @override
  Future<VideoMetadata> getVideo(String videoId) async => const VideoMetadata(
        id: 'v',
        title: 'Live',
        description: 'D',
        channelId: 'UCx',
        channelTitle: 'Ch',
        duration: null,
        isLive: true,
      );
}

void main() {
  test('YouTubeInspector enriches live flag', () async {
    final api = _ApiLive();
    final inspector = YouTubeInspector(api: api);
    final info = await inspector.inspectVideo(
        const VideoRef(videoId: 'v', isLiveCandidate: true, isShort: false));
    expect(info.isLive, true);
    expect(info.isUpcoming, false);
  });
}
