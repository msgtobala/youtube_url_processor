import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_url_processor/youtube_url_processor.dart';

class _FakeApi implements YouTubeDataApi {
  @override
  Future<ChannelMetadata> getChannel(String channelId) async =>
      const ChannelMetadata(id: 'UCx', title: 't', description: 'd');

  @override
  Stream<PlaylistItem> getPlaylistItems(String playlistId,
      {int pageSize = 50}) async* {
    yield const PlaylistItem(videoId: 'v1', title: 'One', index: 0);
    yield const PlaylistItem(videoId: 'v2', title: 'Two', index: 1);
  }

  @override
  Future<PlaylistMetadata> getPlaylist(String playlistId) async =>
      const PlaylistMetadata(
          id: 'PLx', title: 'Playlist', description: 'Desc', itemCount: 2);

  @override
  Future<VideoMetadata> getVideo(String videoId) async => const VideoMetadata(
        id: 'v1',
        title: 'Video',
        description: 'Desc',
        channelId: 'UCx',
        channelTitle: 'Ch',
      );
}

void main() {
  test('fetchEntirePlaylist returns metadata and items', () async {
    final api = _FakeApi();
    final r = await fetchEntirePlaylist(api, 'PLx');
    expect(r.metadata.id, 'PLx');
    expect(r.items.length, 2);
    expect(r.items.first.index, 0);
    expect(r.items.last.videoId, 'v2');
  });
}
