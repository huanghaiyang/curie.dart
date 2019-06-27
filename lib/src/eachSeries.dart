import 'dart:async';

Future<List> eachSeries(List<Function> functions) async {
  Completer<List> overallCompleter = new Completer();
  eachSeriesImpl(functions, 0, new List(), overallCompleter);
  return overallCompleter.future;
}

void eachSeriesImpl(List<Function> functions, int index, List tmpResult,
    Completer<List> overallCompleter) async {
  if (functions.isEmpty || index >= functions.length) {
    return overallCompleter.complete(tmpResult);
  }
  Function future = functions[index];
  dynamic result = await future;
  tmpResult.add(result);
  eachSeriesImpl(functions, index + 1, tmpResult, overallCompleter);
}
