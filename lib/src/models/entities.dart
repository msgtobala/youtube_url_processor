enum YouTubeContentType {
  video,
  short,
  live,
  clip,
  playlist,
  channel,
  unknown,
}

class VideoRef {
  final String videoId;
  final Duration? startAt;
  final Duration? endAt;
  final String? playlistId;
  final int? playlistIndex;
  final bool isShort;
  final bool isLiveCandidate;

  const VideoRef({
    required this.videoId,
    this.startAt,
    this.endAt,
    this.playlistId,
    this.playlistIndex,
    this.isShort = false,
    this.isLiveCandidate = false,
  });
}

class PlaylistRef {
  final String playlistId;
  final String? currentVideoId;
  final int? index;
  final bool isMix;

  const PlaylistRef({
    required this.playlistId,
    this.currentVideoId,
    this.index,
    this.isMix = false,
  });
}

class ChannelRef {
  final String? channelId;
  final String? handle;
  final String? vanity;
  final String? legacyUser;

  const ChannelRef({this.channelId, this.handle, this.vanity, this.legacyUser});
}

class ClipRef {
  final String clipId;
  final String? sourceVideoId;

  const ClipRef({required this.clipId, this.sourceVideoId});
}

class ExtractedEntity {
  final YouTubeContentType type;
  final VideoRef? video;
  final PlaylistRef? playlist;
  final ChannelRef? channel;
  final ClipRef? clip;

  const ExtractedEntity.video(VideoRef v)
      : type = YouTubeContentType.video,
        video = v,
        playlist = null,
        channel = null,
        clip = null;

  const ExtractedEntity.short(VideoRef v)
      : type = YouTubeContentType.short,
        video = v,
        playlist = null,
        channel = null,
        clip = null;

  const ExtractedEntity.live(VideoRef v)
      : type = YouTubeContentType.live,
        video = v,
        playlist = null,
        channel = null,
        clip = null;

  const ExtractedEntity.playlist(PlaylistRef p)
      : type = YouTubeContentType.playlist,
        playlist = p,
        video = null,
        channel = null,
        clip = null;

  const ExtractedEntity.channel(ChannelRef c)
      : type = YouTubeContentType.channel,
        channel = c,
        video = null,
        playlist = null,
        clip = null;

  const ExtractedEntity.clip(ClipRef c)
      : type = YouTubeContentType.clip,
        clip = c,
        video = null,
        playlist = null,
        channel = null;

  const ExtractedEntity.unknown()
      : type = YouTubeContentType.unknown,
        video = null,
        playlist = null,
        channel = null,
        clip = null;
}


