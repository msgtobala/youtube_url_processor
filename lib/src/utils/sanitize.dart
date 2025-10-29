import 'dart:core';

/// Removes tracking or irrelevant parameters and keeps only essential ones for
/// canonicalization and sharing.
Uri sanitizeYouTubeUri(Uri uri) {
  final keep = <String>{'v', 'list', 'index', 't', 'start', 'end'};
  if (uri.queryParameters.isEmpty) return uri;
  final filtered = <String, String>{};
  uri.queryParameters.forEach((k, v) {
    if (keep.contains(k)) {
      filtered[k] = v;
    }
  });
  return uri.replace(queryParameters: filtered.isEmpty ? null : filtered);
}
