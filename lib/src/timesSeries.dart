import 'dart:async';

Future<List> timesSeries(Function function, int times, [Function callback]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List(times);
  int index = 0;
  timesSeriesImpl(function, index, tmpResult, times, completer, callback);
  return completer.future;
}

void timesSeriesImpl(Function function, int index, List tmpResult, int times,
    Completer<List> completer,
    [Function callback]) async {
  if (index >= times) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      callback(tmpResult);
    }
    return;
  }
  try {
    dynamic result = await function();
    tmpResult[index] = result;
  } catch (e) {
    // 忽略错误，继续执行
    tmpResult[index] = null;
  }
  if (index == times - 1) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      callback(tmpResult);
    }
  } else {
    index++;
    timesSeriesImpl(function, index, tmpResult, times, completer, callback);
  }
}
