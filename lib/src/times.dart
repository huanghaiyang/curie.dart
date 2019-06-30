import 'dart:async';

Future<List> times(Function function, int times, [Function callback]) async {
  Completer<List> completer = new Completer();
  List tmpResult = new List(times);
  int completeCounter = 0;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int i = 0; i < times; i++) {
    timeImpl(
        function, incrementCounter, i, tmpResult, times, completer, callback);
  }
  return completer.future;
}

void timeImpl(Function function, Function incrementCounter, int index,
    List tmpResult, int times, Completer<List> completer,
    [Function callback]) async {
  dynamic result = await function();
  tmpResult[index] = result;
  int completeCounter = incrementCounter();
  if (completeCounter == times) {
    completer.complete(tmpResult);
    if (callback != null) {
      callback(tmpResult);
    }
  }
}
