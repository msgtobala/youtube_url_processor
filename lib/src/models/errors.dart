abstract class YouTubeUrlError implements Exception {
  final String message;
  const YouTubeUrlError(this.message);

  @override
  String toString() => message;
}

class InvalidUrlError extends YouTubeUrlError {
  const InvalidUrlError(String message) : super(message);
}

class UnsupportedTypeError extends YouTubeUrlError {
  const UnsupportedTypeError(String message) : super(message);
}

class NetworkError extends YouTubeUrlError {
  final int? statusCode;
  const NetworkError(String message, {this.statusCode}) : super(message);
}

class ApiError extends YouTubeUrlError {
  final int? statusCode;
  const ApiError(String message, {this.statusCode}) : super(message);
}

class NotFoundError extends YouTubeUrlError {
  const NotFoundError(String message) : super(message);
}

class RateLimitedError extends YouTubeUrlError {
  const RateLimitedError(String message) : super(message);
}


