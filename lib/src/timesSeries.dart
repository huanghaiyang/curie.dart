void timesSeries(Function function, int times, [Function callback]) {
  List tmpResult = new List(times);
  int index = 0;
  timesSeriesImpl(function, index, tmpResult, times, callback);
}

void timesSeriesImpl(Function function, int index, List tmpResult, int times,
    [Function callback]) async {
  dynamic result = await function();
  tmpResult[index] = result;
  if (index == times - 1) {
    if (callback != null) {
      callback(tmpResult);
    }
  } else {
    index++;
    timesSeriesImpl(function, index, tmpResult, times);
  }
}
