import 'dart:core';

import 'models/entities.dart';
import 'models/results.dart';
import 'parsing/url_patterns.dart';

class YouTubeUrlExtractor {
  const YouTubeUrlExtractor();

  ParseResult<ExtractedEntity> extract(String inputUrl) {
    Uri uri;
    try {
      uri = Uri.parse(inputUrl);
    } catch (_) {
      return ParseResult.fail('Invalid URL');
    }

    if (!(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      return ParseResult.fail('Unsupported URL scheme');
    }

    final host = uri.host.toLowerCase();
    if (!YouTubeUrlPatterns.hosts.contains(host)) {
      return ParseResult.fail('Not a YouTube URL');
    }

    // Handle youtu.be short links
    if (host.endsWith('youtu.be')) {
      final m = YouTubeUrlPatterns.shortUrl.firstMatch(uri.path);
      if (m != null && m.groupCount >= 1) {
        final videoId = m.group(1)!;
        if (!_isValidVideoId(videoId)) {
          return ParseResult.fail('Invalid video id');
        }
        return ParseResult.ok(
          ExtractedEntity.video(
            VideoRef(
              videoId: videoId,
              startAt: _extractStart(uri),
              endAt: _extractEnd(uri),
              playlistId: _q(uri, 'list'),
              playlistIndex: _qi(uri, 'index'),
            ),
          ),
        );
      }
    }

    // Common paths
    final path = uri.path;
    final qs = uri.queryParameters;

    // /watch?v=
    if (YouTubeUrlPatterns.watch.hasMatch(path)) {
      final v = qs['v'];
      if (v != null && _isValidVideoId(v)) {
        return ParseResult.ok(
          ExtractedEntity.video(
            VideoRef(
              videoId: v,
              startAt: _extractStart(uri),
              endAt: _extractEnd(uri),
              playlistId: qs['list'],
              playlistIndex: _qi(uri, 'index'),
            ),
          ),
        );
      }
    }

    // /shorts/{id}
    final shorts = YouTubeUrlPatterns.shorts.firstMatch(path);
    if (shorts != null) {
      final id = shorts.group(1)!;
      if (_isValidVideoId(id)) {
        return ParseResult.ok(
          ExtractedEntity.short(
            VideoRef(
              videoId: id,
              startAt: _extractStart(uri),
              endAt: _extractEnd(uri),
              isShort: true,
            ),
          ),
        );
      }
    }

    // /embed/{id}
    final embed = YouTubeUrlPatterns.embed.firstMatch(path);
    if (embed != null) {
      final id = embed.group(1)!;
      if (_isValidVideoId(id)) {
        return ParseResult.ok(
          ExtractedEntity.video(
            VideoRef(
              videoId: id,
              startAt: _extractStart(uri),
              endAt: _extractEnd(uri),
            ),
          ),
        );
      }
    }

    // /live/{id}
    final live = YouTubeUrlPatterns.live.firstMatch(path);
    if (live != null) {
      final id = live.group(1)!;
      if (_isValidVideoId(id)) {
        return ParseResult.ok(
          ExtractedEntity.live(VideoRef(videoId: id, isLiveCandidate: true)),
        );
      }
    }

    // /@handle/live → live candidate associated with channel handle
    final hLive = YouTubeUrlPatterns.handleLive.firstMatch(path);
    if (hLive != null) {
      return ParseResult.ok(
        ExtractedEntity.channel(ChannelRef(handle: '@${hLive.group(1)!}')),
      );
    }

    // /c/{vanity}/live → live candidate associated with vanity channel
    final vLive = YouTubeUrlPatterns.vanityLive.firstMatch(path);
    if (vLive != null) {
      return ParseResult.ok(
        ExtractedEntity.channel(ChannelRef(vanity: vLive.group(1)!)),
      );
    }

    // /playlist?list=
    if (YouTubeUrlPatterns.playlist.hasMatch(path)) {
      final list = qs['list'];
      if (list != null && _isValidPlaylistId(list)) {
        return ParseResult.ok(
          ExtractedEntity.playlist(
            PlaylistRef(
              playlistId: list,
              currentVideoId: _q(uri, 'v'),
              index: _qi(uri, 'index'),
              isMix: list.startsWith('RD'),
            ),
          ),
        );
      }
    }

    // /channel/{id}
    final ch = YouTubeUrlPatterns.channel.firstMatch(path);
    if (ch != null) {
      final id = ch.group(1)!;
      return ParseResult.ok(ExtractedEntity.channel(ChannelRef(channelId: id)));
    }

    // /@handle
    final handle = YouTubeUrlPatterns.handle.firstMatch(path);
    if (handle != null) {
      final h = handle.group(1)!;
      return ParseResult.ok(ExtractedEntity.channel(ChannelRef(handle: '@$h')));
    }

    // /c/vanity or /user/legacy
    final vanity = YouTubeUrlPatterns.vanity.firstMatch(path);
    if (vanity != null) {
      return ParseResult.ok(
        ExtractedEntity.channel(ChannelRef(vanity: vanity.group(1)!)),
      );
    }
    final user = YouTubeUrlPatterns.user.firstMatch(path);
    if (user != null) {
      return ParseResult.ok(
        ExtractedEntity.channel(ChannelRef(legacyUser: user.group(1)!)),
      );
    }

    // /clip/{id}
    final clip = YouTubeUrlPatterns.clip.firstMatch(path);
    if (clip != null) {
      return ParseResult.ok(
        ExtractedEntity.clip(ClipRef(clipId: clip.group(1)!)),
      );
    }

    return ParseResult.ok(const ExtractedEntity.unknown());
  }

  bool _isValidVideoId(String id) => YouTubeIdValidators.videoId.hasMatch(id);
  bool _isValidPlaylistId(String id) =>
      YouTubeIdValidators.playlistId.hasMatch(id);

  String? _q(Uri uri, String key) => uri.queryParameters[key];
  int? _qi(Uri uri, String key) => int.tryParse(uri.queryParameters[key] ?? '');

  Duration? _extractStart(Uri uri) =>
      parseTimecode(uri.queryParameters['t'] ?? uri.queryParameters['start']);
  Duration? _extractEnd(Uri uri) => parseTimecode(uri.queryParameters['end']);
}
