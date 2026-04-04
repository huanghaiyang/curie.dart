import 'dart:async';

Future<List> map(List<Function> functions, [Function callback]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List(functions.length);
  int completeCounter = 0;
  bool done = false;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    mapImpl(
        functions, index, tmpResult, completer, incrementCounter, callback, () => done);
  }
  return completer.future;
}

void mapImpl(List<Function> functions, int index, List tmpResult,
    Completer completer, Function incrementCounter, Function callback, Function isDone) async {
  Function function = functions[index];
  try {
    dynamic result = await function();
    if (isDone()) {
      return;
    }
    tmpResult[index] = result;
  } catch (e) {
    // 忽略错误，继续执行
    if (isDone()) {
      return;
    }
    tmpResult[index] = null;
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