import 'dart:async';

Future<List> eachFuture(List<Future> futures) async {
  Completer<List> overallCompleter = new Completer();
  eachFutureImpl(futures, 0, new List(), overallCompleter);
  return overallCompleter.future;
}

void eachFutureImpl(List<Future> futures, int index, List tmpResult,
    Completer<List> overallCompleter) async {
  if (futures.isEmpty || index >= futures.length) {
    return overallCompleter.complete(tmpResult);
  }
  Future future = futures[index];
  dynamic result = await future;
  tmpResult.add(result);
  eachFutureImpl(futures, index + 1, tmpResult, overallCompleter);
}
