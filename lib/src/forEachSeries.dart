import 'dart:async';

Future<void> forEachSeries(List<Function> functions, [Function callback]) {
  Completer<void> completer = new Completer();
  int index = 0;
  forEachSeriesImpl(functions, index, completer, callback);
  return completer.future;
}

void forEachSeriesImpl(List<Function> functions, int index,
    Completer<void> completer, [Function callback]) async {
  if (index >= functions.length) {
    if (!completer.isCompleted) {
      completer.complete();
    }
    if (callback != null) {
      Function.apply(callback, []);
    }
    return;
  }
  Function function = functions[index];
  try {
    await function();
  } catch (e) {
    // 忽略错误，继续执行
  }
  index++;
  forEachSeriesImpl(functions, index, completer, callback);
}