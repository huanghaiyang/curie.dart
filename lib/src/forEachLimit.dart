import 'dart:async';

Future<void> forEachLimit(List<Function> functions, int limit,
    [Function callback]) async {
  Completer<void> completer = new Completer();
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
          await task();
        } catch (e) {
          // 忽略错误，继续执行
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          if (!completer.isCompleted) {
            completer.complete();
          }
          if (callback != null) {
            Function.apply(callback, []);
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