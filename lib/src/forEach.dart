import 'dart:async';

Future<void> forEach(List<Function> functions, [Function callback]) {
  Completer<void> completer = new Completer();
  int completeCounter = 0;
  bool done = false;
  
  // 处理空列表情况
  if (functions.isEmpty) {
    if (!completer.isCompleted) {
      completer.complete();
    }
    if (callback != null) {
      Function.apply(callback, []);
    }
    return completer.future;
  }
  
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    forEachImpl(
        functions, index, completer, incrementCounter, callback, () => done);
  }
  return completer.future;
}

void forEachImpl(List<Function> functions, int index,
    Completer completer, Function incrementCounter, Function callback, Function isDone) async {
  Function function = functions[index];
  try {
    await function();
  } catch (e) {
    // 忽略错误，继续执行
  }
  int counter = incrementCounter();
  if (counter == functions.length) {
    if (!completer.isCompleted) {
      completer.complete();
    }
    if (callback != null) {
      Function.apply(callback, []);
    }
  }
}