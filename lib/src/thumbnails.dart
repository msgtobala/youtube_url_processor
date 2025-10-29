enum YouTubeThumbnailQuality { defaultRes, mq, hq, sd, maxres }

class YouTubeThumbnails {
  static Uri url(
    String videoId, {
    YouTubeThumbnailQuality quality = YouTubeThumbnailQuality.hq,
    bool webp = false,
  }) {
    final q = switch (quality) {
      YouTubeThumbnailQuality.defaultRes => 'default',
      YouTubeThumbnailQuality.mq => 'mqdefault',
      YouTubeThumbnailQuality.hq => 'hqdefault',
      YouTubeThumbnailQuality.sd => 'sddefault',
      YouTubeThumbnailQuality.maxres => 'maxresdefault',
    };
    final ext = webp ? 'webp' : 'jpg';
    return Uri.parse('https://i.ytimg.com/vi/$videoId/$q.$ext');
  }
}
