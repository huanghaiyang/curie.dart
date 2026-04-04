import 'dart:async';

Future<List> filter(List<Function> functions, Function predicate, [Function callback]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List();
  List<bool> results = new List(functions.length);
  int completeCounter = 0;
  bool done = false;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    filterImpl(
        functions, index, predicate, results, tmpResult, completer, incrementCounter, callback, () => done);
  }
  return completer.future;
}

void filterImpl(List<Function> functions, int index, Function predicate, List<bool> results, List tmpResult,
    Completer completer, Function incrementCounter, Function callback, Function isDone) async {
  Function function = functions[index];
  try {
    dynamic result = await function();
    if (isDone()) {
      return;
    }
    bool shouldInclude = await predicate(result);
    if (isDone()) {
      return;
    }
    results[index] = shouldInclude;
    if (shouldInclude) {
      tmpResult.add(result);
    }
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
    results[index] = false;
  }
  int counter = incrementCounter();
  if (counter == functions.length) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      Function.apply(callback, [tmpResult]);
    }
  }
}