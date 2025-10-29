import 'api/yt_data_api.dart';

class PlaylistFetchResult {
  final PlaylistMetadata metadata;
  final List<PlaylistItem> items;
  const PlaylistFetchResult({required this.metadata, required this.items});
}

Future<PlaylistFetchResult> fetchEntirePlaylist(
  YouTubeDataApi api,
  String playlistId, {
  int pageSize = 50,
}) async {
  final meta = await api.getPlaylist(playlistId);
  final items = <PlaylistItem>[];
  await for (final item in api.getPlaylistItems(playlistId, pageSize: pageSize)) {
    items.add(item);
  }
  return PlaylistFetchResult(metadata: meta, items: items);
}


