abstract class Either<T, E> {
  final T? _value;
  final E? _error;

  Either.success(this._value) : _error = null;
  Either.error(this._error) : _value = null;

  bool get isSuccess => _value != null;
  bool get isError => _error != null;

  T get value {
    if (_value == null) {
      throw Exception("Cannot retrieve value from an error Either");
    }
    return _value!;
  }

  E get error {
    if (_error == null) {
      throw Exception("Cannot retrieve error from a successful Either");
    }
    return _error!;
  }
}
