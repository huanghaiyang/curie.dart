import 'dart:async';

Future<bool> some(List<Function> functions,
    [Function callback, bool immediateEnd = true]) {
  Completer<bool> completer = new Completer();
  List<bool> tmpResult = new List(functions.length);
  int completeCounter = 0;
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    someImpl(
        functions, index, tmpResult, completer, incrementCounter, callback);
  }
  return completer.future;
}

void someImpl(List<Function> functions, int index, List tmpResult,
    Completer completer, Function incrementCounter, Function callback) async {
  Function function = functions[index];
  bool result = await function();
  tmpResult[index] = result;
  if (result) {
    completer.complete(result);
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
