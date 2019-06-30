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
  dynamic result = await function();
  tmpResult[index] = result;
  if (index == times - 1) {
    completer.complete(tmpResult);
    if (callback != null) {
      callback(tmpResult);
    }
  } else {
    index++;
    timesSeriesImpl(function, index, tmpResult, times, completer, callback);
  }
}
