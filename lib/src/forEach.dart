import 'dart:async';
import 'utils.dart';

Future<void> forEach(List<Function> functions, [Function callback]) {
  Completer<void> completer = new Completer();
  int completeCounter = 0;
  bool done = false;
  
  // 处理空列表情况
  handleEmptyList(functions, completer, null, callback);
  if (functions.isEmpty) {
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
  // 执行任务
  await executeTask(functions[index], null, isDone);
  
  // 处理任务完成
  int counter = incrementCounter();
  handleTaskComplete(counter, functions.length, completer, null, callback);
}