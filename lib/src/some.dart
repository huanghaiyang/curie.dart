import 'dart:async';

Future<bool> some(List<Function> functions, [Function callback]) {
  Completer<bool> completer = new Completer();
  List<bool> tmpResult = new List(functions.length);
  int completeCounter = 0;
  bool done = false;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    someImpl(
        functions, index, tmpResult, completer, incrementCounter, callback, () => done);
  }
  return completer.future;
}

void someImpl(List<Function> functions, int index, List tmpResult,
    Completer completer, Function incrementCounter, Function callback, Function isDone) async {
  Function function = functions[index];
  try {
    bool result = await function();
    if (isDone()) {
      return;
    }
    tmpResult[index] = result;
    if (result) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    }
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
    tmpResult[index] = false;
  }
  int counter = incrementCounter();
  if (counter == functions.length) {
    if (!completer.isCompleted) {
      completer.complete(false);
    }
    if (callback != null) {
      Function.apply(callback, [tmpResult]);
    }
  }
}
