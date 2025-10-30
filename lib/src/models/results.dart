/// Result type used by parsers in this package.
class ParseResult<T> {
  final T? value;
  final String? error;

  /// Private constructor used by [ok] and [fail].
  const ParseResult._(this.value, this.error);

  /// Whether the result represents a successful parse.
  bool get isSuccess => error == null;

  /// Construct a successful result carrying [value].
  static ParseResult<T> ok<T>(T value) => ParseResult._(value, null);

  /// Construct a failed result with an error [message].
  static ParseResult<T> fail<T>(String message) => ParseResult._(null, message);
}
