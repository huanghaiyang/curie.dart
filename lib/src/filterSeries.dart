import 'dart:async';

Future<List> filterSeries(List<Function> functions, Function predicate, [Function callback]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List();
  int index = 0;
  filterSeriesImpl(functions, index, predicate, tmpResult, completer, callback);
  return completer.future;
}

void filterSeriesImpl(List<Function> functions, int index, Function predicate, List tmpResult,
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
    bool shouldInclude = await predicate(result);
    if (shouldInclude) {
      tmpResult.add(result);
    }
  } catch (e) {
    // 忽略错误，继续执行
  }
  index++;
  filterSeriesImpl(functions, index, predicate, tmpResult, completer, callback);
}