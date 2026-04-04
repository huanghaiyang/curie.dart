import 'dart:async';

Future<dynamic> reduce(List<Function> functions, Function reducer, [dynamic initialValue, Function callback]) {
  Completer<dynamic> completer = new Completer();
  List results = new List();
  int completeCounter = 0;
  bool done = false;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    reduceImpl(
        functions, index, results, completer, incrementCounter, reducer, initialValue, callback, () => done);
  }
  return completer.future;
}

void reduceImpl(List<Function> functions, int index, List results,
    Completer completer, Function incrementCounter, Function reducer, dynamic initialValue, Function callback, Function isDone) async {
  Function function = functions[index];
  try {
    dynamic result = await function();
    if (isDone()) {
      return;
    }
    results.add(result);
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
    results.add(null);
  }
  int counter = incrementCounter();
  if (counter == functions.length) {
    dynamic result = initialValue;
    for (dynamic value in results) {
      if (value != null) {
        result = reducer(result, value);
      }
    }
    if (!completer.isCompleted) {
      completer.complete(result);
    }
    if (callback != null) {
      Function.apply(callback, [result]);
    }
  }
}