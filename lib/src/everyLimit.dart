import 'dart:async';

Future<bool> everyLimit(List<Function> functions, int limit,
    [Function callback, bool immediateEnd = true]) {
  Completer<bool> completer = new Completer();
  Map<int, bool> result = new Map();
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  void execute([int currIndex]) async {
    if (completer.isCompleted && immediateEnd) {
      return;
    }
    if (currIndex != null) {
      running++;
      int taskIndex = currIndex;
      if (taskIndex < functions.length && !done) {
        Function task = functions[taskIndex];
        try {
          bool value = await task();
          if (done) {
            running--;
            return;
          }
          result[taskIndex] = value;
          if (!value) {
            if (!completer.isCompleted) {
              completer.complete(false);
            }
            if (immediateEnd) {
              done = true;
              if (callback != null) {
                Function.apply(callback, [result]);
              }
            }
          }
        } catch (e) {
          // 忽略错误，继续执行
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          if (!completer.isCompleted) {
            completer.complete(true);
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
