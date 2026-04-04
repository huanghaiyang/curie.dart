import 'dart:async';

Future<List> times(Function function, int times, [Function callback]) async {
  Completer<List> completer = new Completer();
  List tmpResult = new List(times);
  int completeCounter = 0;
  bool done = false;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int i = 0; i < times; i++) {
    timeImpl(
        function, incrementCounter, i, tmpResult, times, completer, callback, () => done);
  }
  return completer.future;
}

void timeImpl(Function function, Function incrementCounter, int index,
    List tmpResult, int times, Completer<List> completer, Function callback, Function isDone) async {
  try {
    dynamic result = await function();
    if (isDone()) {
      return;
    }
    tmpResult[index] = result;
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
    tmpResult[index] = null;
  }
  int completeCounter = incrementCounter();
  if (completeCounter == times) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      callback(tmpResult);
    }
  }
}
