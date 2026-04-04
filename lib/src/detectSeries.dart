import 'dart:async';

Future<dynamic> detectSeries(List<Function> functions, Function predicate, [Function callback]) {
  Completer<dynamic> completer = new Completer();
  int index = 0;
  detectSeriesImpl(functions, index, predicate, completer, callback);
  return completer.future;
}

void detectSeriesImpl(List<Function> functions, int index, Function predicate,
    Completer<dynamic> completer, [Function callback]) async {
  if (index >= functions.length) {
    if (!completer.isCompleted) {
      completer.complete(null);
    }
    if (callback != null) {
      Function.apply(callback, [null]);
    }
    return;
  }
  Function function = functions[index];
  try {
    dynamic result = await function();
    bool shouldInclude = await predicate(result);
    if (shouldInclude) {
      if (!completer.isCompleted) {
        completer.complete(result);
      }
      if (callback != null) {
        Function.apply(callback, [result]);
      }
      return;
    }
  } catch (e) {
    // 忽略错误，继续执行
  }
  index++;
  detectSeriesImpl(functions, index, predicate, completer, callback);
}