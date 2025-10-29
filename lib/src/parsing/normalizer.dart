import 'dart:core';

import '../models/entities.dart';
import '../utils/timecode.dart';

class YouTubeUrlNormalizer {
  static Uri canonicalWatchUrl(VideoRef ref) {
    final params = <String, String>{'v': ref.videoId};
    if (ref.startAt != null) params['t'] = formatTimecode(ref.startAt!);
    if (ref.endAt != null) params['end'] = formatTimecode(ref.endAt!);
    if (ref.playlistId != null) {
      params['list'] = ref.playlistId!;
    }
    if (ref.playlistIndex != null) {
      params['index'] = ref.playlistIndex!.toString();
    }
    return Uri.https('www.youtube.com', '/watch', params);
  }

  static Uri canonicalShortsUrl(String videoId) =>
      Uri.https('www.youtube.com', '/shorts/$videoId');

  static Uri embedUrl(String videoId, {bool privacyEnhanced = false}) {
    final host = privacyEnhanced
        ? 'www.youtube-nocookie.com'
        : 'www.youtube.com';
    return Uri.https(host, '/embed/$videoId');
  }

  static Uri playlistUrl(PlaylistRef ref) {
    final params = <String, String>{'list': ref.playlistId};
    if (ref.currentVideoId != null) {
      params['v'] = ref.currentVideoId!;
    }
    if (ref.index != null) {
      params['index'] = ref.index!.toString();
    }
    return Uri.https('www.youtube.com', '/playlist', params);
  }

  static Uri liveChannelUrl({
    String? handle,
    String? vanity,
    String? channelId,
  }) {
    if (handle != null && handle.isNotEmpty) {
      final h = handle.startsWith('@') ? handle : '@$handle';
      return Uri.https('www.youtube.com', '/$h/live');
    }
    if (vanity != null && vanity.isNotEmpty) {
      return Uri.https('www.youtube.com', '/c/$vanity/live');
    }
    if (channelId != null && channelId.isNotEmpty) {
      return Uri.https('www.youtube.com', '/channel/$channelId/live');
    }
    throw ArgumentError('One of handle, vanity or channelId must be provided');
  }

  static Uri watchUrl({
    required String videoId,
    Duration? startAt,
    Duration? endAt,
    String? playlistId,
    int? playlistIndex,
  }) {
    return canonicalWatchUrl(
      VideoRef(
        videoId: videoId,
        startAt: startAt,
        endAt: endAt,
        playlistId: playlistId,
        playlistIndex: playlistIndex,
      ),
    );
  }

  static Uri? canonicalFromEntity(ExtractedEntity entity) {
    switch (entity.type) {
      case YouTubeContentType.video:
      case YouTubeContentType.live:
      case YouTubeContentType.short:
        final v = entity.video!;
        return canonicalWatchUrl(v);
      case YouTubeContentType.playlist:
        return playlistUrl(entity.playlist!);
      case YouTubeContentType.channel:
        final c = entity.channel!;
        if (c.channelId != null) {
          return Uri.https('www.youtube.com', '/channel/${c.channelId}');
        }
        if (c.handle != null) {
          final h = c.handle!.startsWith('@') ? c.handle! : '@${c.handle}';
          return Uri.https('www.youtube.com', '/$h');
        }
        if (c.vanity != null) {
          return Uri.https('www.youtube.com', '/c/${c.vanity}');
        }
        if (c.legacyUser != null) {
          return Uri.https('www.youtube.com', '/user/${c.legacyUser}');
        }
        return null;
      case YouTubeContentType.clip:
      case YouTubeContentType.unknown:
        return null;
    }
  }
}
