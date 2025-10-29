String formatTimecode(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) return '${h}h${m}m${s}s';
  if (m > 0) return '${m}m${s}s';
  return '${s}s';
}
