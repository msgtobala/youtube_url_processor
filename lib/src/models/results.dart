class ParseResult<T> {
  final T? value;
  final String? error;

  const ParseResult._(this.value, this.error);

  bool get isSuccess => error == null;

  static ParseResult<T> ok<T>(T value) => ParseResult._(value, null);

  static ParseResult<T> fail<T>(String message) => ParseResult._(null, message);
}


