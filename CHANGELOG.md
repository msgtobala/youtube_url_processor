# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-10-30

### Fixed

- Resolved static analysis lints by adopting Dart super-parameters for error
  types in `src/models/errors.dart`.

### Added

- Public API documentation across core models, extractor, and API types to
  satisfy documentation coverage requirements.

### Changed

- Library-level docs for `youtube_url_processor.dart` for better discoverability.

## [0.1.1] - 2025-10-29

### Fixed

- Minor cleanups and metadata updates in preparation for publication.

## [0.1.0] - 2025-10-28

### Added

- Initial release.
- Core parsing and normalization for YouTube URLs (video/short/live/clip/playlist/channel)
- URL builders (watch/shorts/embed/playlist/live) and timecode formatting
- Thumbnail utilities and Flutter `YouTubeThumbnail` widget
- Metadata: oEmbed with OpenGraph fallback; unified metadata client
- Optional YouTube Data API v3 client with playlist pagination
- Flutter `YouTubeLinkPreview` and `YouTubeEmbedView` widgets
- Utilities: URL sanitation, playlist helpers, live/shorts inspector
- Documentation and tests
