class YouTubeIdValidators {
  static final RegExp videoId = RegExp(r'^[a-zA-Z0-9_-]{11}$');
  static final RegExp playlistId = RegExp(
    r'^(PL|UU|LL|RD|OLAK5uy|WL)[a-zA-Z0-9_-]{10,}$',
  );
  static final RegExp channelId = RegExp(r'^UC[a-zA-Z0-9_-]{22}$');
  static final RegExp clipId = RegExp(r'^[a-zA-Z0-9_-]{12,}$');
  static final RegExp handle = RegExp(r'^@[A-Za-z0-9._-]{3,30}$');
}

class YouTubeUrlPatterns {
  // Hosts
  static const hosts = {
    'youtu.be',
    'www.youtu.be',
    'youtube.com',
    'www.youtube.com',
    'm.youtube.com',
    'music.youtube.com',
    'www.youtube-nocookie.com',
    'youtube-nocookie.com',
  };

  // Paths
  static final RegExp watch = RegExp(r'^/watch$');
  static final RegExp embed = RegExp(r'^/embed/([a-zA-Z0-9_-]{11})$');
  static final RegExp shortUrl = RegExp(
    r'^/([a-zA-Z0-9_-]{11})$',
  ); // youtu.be/{id}
  static final RegExp shorts = RegExp(r'^/shorts/([a-zA-Z0-9_-]{11})$');
  static final RegExp live = RegExp(r'^/live/([a-zA-Z0-9_-]{11})$');
  static final RegExp handleLive = RegExp(r'^/@([A-Za-z0-9._-]{3,30})/live$');
  static final RegExp vanityLive = RegExp(r'^/c/([A-Za-z0-9_-]+)/live$');
  static final RegExp clip = RegExp(r'^/clip/([a-zA-Z0-9_-]{12,})$');
  static final RegExp playlist = RegExp(r'^/playlist$');
  static final RegExp channel = RegExp(r'^/channel/(UC[a-zA-Z0-9_-]{22})$');
  static final RegExp user = RegExp(r'^/user/([A-Za-z0-9]+)$');
  static final RegExp vanity = RegExp(r'^/c/([A-Za-z0-9_-]+)$');
  static final RegExp handle = RegExp(r'^/@([A-Za-z0-9._-]{3,30})$');
}

Duration? parseTimecode(String? t) {
  if (t == null || t.isEmpty) return null;
  // Supports 1h2m3s or seconds only
  final hms = RegExp(r'(?:(\d+)h)?(?:(\d+)m)?(?:(\d+)s)?');
  final m = hms.firstMatch(t);
  if (m != null && m.group(0)!.isNotEmpty) {
    final h = int.tryParse(m.group(1) ?? '0') ?? 0;
    final mnt = int.tryParse(m.group(2) ?? '0') ?? 0;
    final s = int.tryParse(m.group(3) ?? '0') ?? 0;
    return Duration(hours: h, minutes: mnt, seconds: s);
  }
  final seconds = int.tryParse(t);
  if (seconds != null) return Duration(seconds: seconds);
  return null;
}
