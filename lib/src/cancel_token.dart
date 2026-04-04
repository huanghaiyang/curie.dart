import 'dart:async';

class CancelToken {
  bool _isCancelled = false;
  Completer<void> _completer;

  bool get isCancelled => _isCancelled;

  Future<void> get whenCancelled {
    if (_isCancelled) {
      return Future.value();
    }
    _completer ??= Completer<void>();
    return _completer.future;
  }

  void cancel() {
    if (!_isCancelled) {
      _isCancelled = true;
      if (_completer != null && !_completer.isCompleted) {
        _completer.complete();
      }
    }
  }
}

class CancelException implements Exception {
  final String message;
  CancelException(this.message);
  @override
  String toString() => message;
}
