import 'dart:async';

Future<List> series(List<Function> functions, [Function callback]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List(functions.length);
  int index = 0;
  seriesImpl(functions, index, tmpResult, completer, callback);
  return completer.future;
}

void seriesImpl(List<Function> functions, int index, List tmpResult,
    Completer<List> completer, [Function callback]) async {
  if (index >= functions.length) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      Function.apply(callback, [tmpResult]);
    }
    return;
  }
  Function function = functions[index];
  try {
    dynamic result = await function();
    tmpResult[index] = result;
  } catch (e) {
    // 忽略错误，继续执行
    tmpResult[index] = null;
  }
  index++;
  seriesImpl(functions, index, tmpResult, completer, callback);
}