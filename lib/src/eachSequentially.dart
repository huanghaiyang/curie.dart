import 'dart:async';

Future<List> eachSequentially(List<Future> futures) async {
  Completer<List> overallCompleter = new Completer();
  eachSequentiallyImpl(futures, 0, new List(), overallCompleter);
  return overallCompleter.future;
}

void eachSequentiallyImpl(List<Future> futures, int index, List tmpResult,
    Completer<List> overallCompleter) {
  if (futures.isEmpty || index >= futures.length) {
    return overallCompleter.complete(tmpResult);
  }
  Future future = futures[index];
  future.then((value) {
    tmpResult.add(value);
  }).catchError((error) {
    overallCompleter.completeError(error);
  }).whenComplete(() {
    eachSequentiallyImpl(futures, index + 1, tmpResult, overallCompleter);
  });
}
