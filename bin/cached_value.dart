import 'dart:async';

class CachedValue<T> {
  T? value;
  DateTime? _expiresAt;

  final Duration expiresIn;
  final FutureOr<T> Function() fetch;

  CachedValue(this.fetch, this.expiresIn);

  Future<T> get() async {
    final expiresAt = this._expiresAt;
    if (expiresAt == null || expiresAt.isBefore(DateTime.now())) {
      value = await fetch();
      _expiresAt = DateTime.now().add(expiresIn);
    }
    return value!;
  }
}
