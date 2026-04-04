import 'dart:async';

Future<List> mapLimit(List<Function> functions, int limit,
    [Function callback]) async {
  Completer<List> completer = new Completer();
  List result = new List(functions.length);
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  void execute([int currIndex]) async {
    if (completer.isCompleted) {
      return;
    }
    if (currIndex != null) {
      running++;
      int taskIndex = currIndex;
      if (taskIndex < functions.length && !done) {
        Function task = functions[taskIndex];
        try {
          dynamic value = await task();
          if (done) {
            running--;
            return;
          }
          result[taskIndex] = value;
        } catch (e) {
          // 忽略错误，继续执行
          if (done) {
            running--;
            return;
          }
          result[taskIndex] = null;
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          if (!completer.isCompleted) {
            completer.complete(result);
          }
          if (callback != null) {
            Function.apply(callback, [result]);
          }
        } else if (!done) {
          if (!looping) {
            execute();
          }
        }
      } else {
        running--;
      }
    } else {
      looping = true;
      while (running < limit && !done && index < functions.length) {
        int currentIndex = index;
        index++;
        execute(currentIndex);
      }
    }
  }

  execute();
  return completer.future;
}