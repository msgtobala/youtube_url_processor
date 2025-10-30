/// Base class for all errors thrown by the youtube_url_processor package.
///
/// The [message] should contain a concise, user-friendly description of the
/// failure which is also returned by [toString].
abstract class YouTubeUrlError implements Exception {
  /// Human-readable error message describing the failure.
  final String message;

  /// Creates an error with the provided [message].
  const YouTubeUrlError(this.message);

  @override
  String toString() => message;
}

/// Thrown when the provided URL cannot be parsed as a valid YouTube URL.
class InvalidUrlError extends YouTubeUrlError {
  /// Creates an [InvalidUrlError] with the given [message].
  const InvalidUrlError(super.message);
}

/// Thrown when the URL is valid but refers to an unsupported YouTube type.
class UnsupportedTypeError extends YouTubeUrlError {
  /// Creates an [UnsupportedTypeError] with the given [message].
  const UnsupportedTypeError(super.message);
}

/// Thrown when a network call fails.
class NetworkError extends YouTubeUrlError {
  /// Optional HTTP status code that accompanied the failure, if available.
  final int? statusCode;

  /// Creates a [NetworkError] with [message] and optional [statusCode].
  const NetworkError(super.message, {this.statusCode});
}

/// Thrown when the YouTube API responds with an error.
class ApiError extends YouTubeUrlError {
  /// Optional HTTP status code that accompanied the API error, if available.
  final int? statusCode;

  /// Creates an [ApiError] with [message] and optional [statusCode].
  const ApiError(super.message, {this.statusCode});
}

/// Thrown when a requested resource is not found.
class NotFoundError extends YouTubeUrlError {
  /// Creates a [NotFoundError] with the given [message].
  const NotFoundError(super.message);
}

/// Thrown when requests are rate limited by the remote service.
class RateLimitedError extends YouTubeUrlError {
  /// Creates a [RateLimitedError] with the given [message].
  const RateLimitedError(super.message);
}
