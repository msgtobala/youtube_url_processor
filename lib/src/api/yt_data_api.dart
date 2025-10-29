import '../models/errors.dart';

class VideoMetadata {
  final String id;
  final String title;
  final String description;
  final Duration? duration;
  final String channelId;
  final String channelTitle;
  final DateTime? publishedAt;
  final bool isLive;
  final bool isUpcoming;

  const VideoMetadata({
    required this.id,
    required this.title,
    required this.description,
    required this.channelId,
    required this.channelTitle,
    this.duration,
    this.publishedAt,
    this.isLive = false,
    this.isUpcoming = false,
  });
}

class PlaylistMetadata {
  final String id;
  final String title;
  final String description;
  final int? itemCount;

  const PlaylistMetadata({
    required this.id,
    required this.title,
    required this.description,
    this.itemCount,
  });
}

class ChannelMetadata {
  final String id;
  final String title;
  final String description;
  final int? subscriberCount;

  const ChannelMetadata({
    required this.id,
    required this.title,
    required this.description,
    this.subscriberCount,
  });
}

class PlaylistItem {
  final String videoId;
  final String title;
  final int index;

  const PlaylistItem({required this.videoId, required this.title, required this.index});
}

abstract class YouTubeDataApi {
  Future<VideoMetadata> getVideo(String videoId);
  Future<PlaylistMetadata> getPlaylist(String playlistId);
  Future<ChannelMetadata> getChannel(String channelId);
  Stream<PlaylistItem> getPlaylistItems(String playlistId, {int pageSize = 50});
}

class NotConfiguredYouTubeDataApi implements YouTubeDataApi {
  const NotConfiguredYouTubeDataApi();

  Never _err() => throw const ApiError('YouTube Data API is not configured');

  @override
  Future<VideoMetadata> getVideo(String videoId) async => _err();

  @override
  Future<PlaylistMetadata> getPlaylist(String playlistId) async => _err();

  @override
  Future<ChannelMetadata> getChannel(String channelId) async => _err();

  @override
  Stream<PlaylistItem> getPlaylistItems(String playlistId, {int pageSize = 50}) async* {
    _err();
  }
}


