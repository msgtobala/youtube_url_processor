import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/errors.dart';
import 'yt_data_api.dart';

class YouTubeDataApiV3 implements YouTubeDataApi {
  final String apiKey;
  final http.Client _client;

  YouTubeDataApiV3({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client();

  static const _base = 'www.googleapis.com';

  @override
  Future<VideoMetadata> getVideo(String videoId) async {
    final uri = Uri.https(_base, '/youtube/v3/videos', {
      'key': apiKey,
      'id': videoId,
      'part': 'snippet,contentDetails,liveStreamingDetails',
      'fields':
          'items(id,snippet(title,description,channelId,channelTitle,publishedAt,liveBroadcastContent),contentDetails(duration),liveStreamingDetails(scheduledStartTime,actualStartTime,actualEndTime))',
      'maxResults': '1',
    });
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw ApiError('YouTube API error', statusCode: res.statusCode);
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final items = map['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) {
      throw const NotFoundError('Video not found');
    }
    final it = items.first as Map<String, dynamic>;
    final snippet = it['snippet'] as Map<String, dynamic>;
    final content = (it['contentDetails'] as Map<String, dynamic>?);
    final durationIso = content?['duration'] as String?; // ISO8601 duration
    final duration = _parseIsoDuration(durationIso);
    final lbc =
        snippet['liveBroadcastContent'] as String?; // none/live/upcoming
    final isLive = lbc == 'live';
    final isUpcoming = lbc == 'upcoming';
    final publishedAt = (snippet['publishedAt'] as String?) != null
        ? DateTime.tryParse(snippet['publishedAt'] as String)
        : null;
    return VideoMetadata(
      id: it['id'] as String,
      title: (snippet['title'] ?? '') as String,
      description: (snippet['description'] ?? '') as String,
      channelId: (snippet['channelId'] ?? '') as String,
      channelTitle: (snippet['channelTitle'] ?? '') as String,
      duration: duration,
      publishedAt: publishedAt,
      isLive: isLive,
      isUpcoming: isUpcoming,
    );
  }

  @override
  Future<PlaylistMetadata> getPlaylist(String playlistId) async {
    final uri = Uri.https(_base, '/youtube/v3/playlists', {
      'key': apiKey,
      'id': playlistId,
      'part': 'snippet,contentDetails',
      'fields':
          'items(id,snippet(title,description),contentDetails(itemCount))',
      'maxResults': '1',
    });
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw ApiError('YouTube API error', statusCode: res.statusCode);
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final items = map['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) {
      throw const NotFoundError('Playlist not found');
    }
    final it = items.first as Map<String, dynamic>;
    final snippet = it['snippet'] as Map<String, dynamic>;
    final cd = it['contentDetails'] as Map<String, dynamic>;
    return PlaylistMetadata(
      id: it['id'] as String,
      title: (snippet['title'] ?? '') as String,
      description: (snippet['description'] ?? '') as String,
      itemCount: (cd['itemCount'] as num?)?.toInt(),
    );
  }

  @override
  Future<ChannelMetadata> getChannel(String channelId) async {
    final uri = Uri.https(_base, '/youtube/v3/channels', {
      'key': apiKey,
      'id': channelId,
      'part': 'snippet,statistics',
      'fields':
          'items(id,snippet(title,description),statistics(subscriberCount))',
      'maxResults': '1',
    });
    final res = await _client.get(uri);
    if (res.statusCode != 200) {
      throw ApiError('YouTube API error', statusCode: res.statusCode);
    }
    final map = json.decode(res.body) as Map<String, dynamic>;
    final items = map['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) {
      throw const NotFoundError('Channel not found');
    }
    final it = items.first as Map<String, dynamic>;
    final snippet = it['snippet'] as Map<String, dynamic>;
    final stats = it['statistics'] as Map<String, dynamic>;
    return ChannelMetadata(
      id: it['id'] as String,
      title: (snippet['title'] ?? '') as String,
      description: (snippet['description'] ?? '') as String,
      subscriberCount: (stats['subscriberCount'] as num?)?.toInt(),
    );
  }

  @override
  Stream<PlaylistItem> getPlaylistItems(String playlistId,
      {int pageSize = 50}) async* {
    String? pageToken;
    do {
      final uri = Uri.https(_base, '/youtube/v3/playlistItems', {
        'key': apiKey,
        'playlistId': playlistId,
        'part': 'snippet',
        'maxResults': pageSize.toString(),
        'pageToken': pageToken ?? '',
        'fields':
            'items(snippet(resourceId(videoId),title,position)),nextPageToken',
      });
      final res = await _client.get(uri);
      if (res.statusCode != 200) {
        throw ApiError('YouTube API error', statusCode: res.statusCode);
      }
      final map = json.decode(res.body) as Map<String, dynamic>;
      final items = (map['items'] as List<dynamic>? ?? []);
      for (final raw in items) {
        final s =
            (raw as Map<String, dynamic>)['snippet'] as Map<String, dynamic>;
        final rid = s['resourceId'] as Map<String, dynamic>;
        yield PlaylistItem(
          videoId: (rid['videoId'] ?? '') as String,
          title: (s['title'] ?? '') as String,
          index: (s['position'] as num).toInt(),
        );
      }
      pageToken = map['nextPageToken'] as String?;
    } while (pageToken != null && pageToken.isNotEmpty);
  }

  Duration? _parseIsoDuration(String? iso) {
    if (iso == null) return null;
    // Simple ISO8601 duration parser for PT#H#M#S
    final re = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final m = re.firstMatch(iso);
    if (m == null) return null;
    final h = int.tryParse(m.group(1) ?? '0') ?? 0;
    final mm = int.tryParse(m.group(2) ?? '0') ?? 0;
    final s = int.tryParse(m.group(3) ?? '0') ?? 0;
    return Duration(hours: h, minutes: mm, seconds: s);
  }
}
