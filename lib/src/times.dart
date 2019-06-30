import 'dart:async';

void times(Function function, int times, [Function callback]) {
  List tmpResult = new List(times);
  int completeCounter = 0;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int i = 0; i < times; i++) {
    timeImpl(function, incrementCounter, i, tmpResult, times, callback);
  }
}

Future timeImpl(Function function, Function incrementCounter, int index,
    List tmpResult, int times,
    [Function callback]) async {
  dynamic result = await function();
  tmpResult[index] = result;
  int completeCounter = incrementCounter();
  if (completeCounter == times) {
    if (callback != null) {
      callback(tmpResult);
    }
  }
}
