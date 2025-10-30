import '../models/errors.dart';

/// Basic information about a YouTube video.
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

  /// Creates a [VideoMetadata] instance.
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

/// Basic information about a YouTube playlist.
class PlaylistMetadata {
  final String id;
  final String title;
  final String description;
  final int? itemCount;

  /// Creates a [PlaylistMetadata] instance.
  const PlaylistMetadata({
    required this.id,
    required this.title,
    required this.description,
    this.itemCount,
  });
}

/// Basic information about a YouTube channel.
class ChannelMetadata {
  final String id;
  final String title;
  final String description;
  final int? subscriberCount;

  /// Creates a [ChannelMetadata] instance.
  const ChannelMetadata({
    required this.id,
    required this.title,
    required this.description,
    this.subscriberCount,
  });
}

/// A single item (video) within a playlist.
class PlaylistItem {
  final String videoId;
  final String title;
  final int index;

  /// Creates a [PlaylistItem] with positional [index] within the playlist.
  const PlaylistItem(
      {required this.videoId, required this.title, required this.index});
}

/// Interface for retrieving metadata via the YouTube Data API.
abstract class YouTubeDataApi {
  /// Fetch metadata for a video by its [videoId].
  Future<VideoMetadata> getVideo(String videoId);

  /// Fetch metadata for a playlist by its [playlistId].
  Future<PlaylistMetadata> getPlaylist(String playlistId);

  /// Fetch metadata for a channel by its [channelId].
  Future<ChannelMetadata> getChannel(String channelId);

  /// Stream the items within a playlist, optionally paging with [pageSize].
  Stream<PlaylistItem> getPlaylistItems(String playlistId, {int pageSize = 50});
}

/// Default implementation used when no API client is configured. All calls
/// throw an [ApiError] to signal that the feature is unavailable.
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
  Stream<PlaylistItem> getPlaylistItems(String playlistId,
      {int pageSize = 50}) async* {
    _err();
  }
}
