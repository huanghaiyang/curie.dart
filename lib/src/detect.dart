import 'dart:async';

Future<dynamic> detect(List<Function> functions, Function predicate, [Function callback]) {
  Completer<dynamic> completer = new Completer();
  bool done = false;
  int completeCounter = 0;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    detectImpl(
        functions, index, predicate, completer, incrementCounter, callback, () => done, () => done = true);
  }
  return completer.future;
}

void detectImpl(List<Function> functions, int index, Function predicate,
    Completer completer, Function incrementCounter, Function callback, Function isDone, Function setDone) async {
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
    if (shouldInclude) {
      setDone();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
      if (callback != null) {
        Function.apply(callback, [result]);
      }
    }
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
  }
  int counter = incrementCounter();
  if (counter == functions.length && !isDone()) {
    if (!completer.isCompleted) {
      completer.complete(null);
    }
    if (callback != null) {
      Function.apply(callback, [null]);
    }
  }
}