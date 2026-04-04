import 'dart:async';

Future<dynamic> detectLimit(List<Function> functions, Function predicate, int limit,
    [Function callback]) async {
  Completer<dynamic> completer = new Completer();
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
          bool shouldInclude = await predicate(value);
          if (done) {
            running--;
            return;
          }
          if (shouldInclude) {
            done = true;
            if (!completer.isCompleted) {
              completer.complete(value);
            }
            if (callback != null) {
              Function.apply(callback, [value]);
            }
          }
        } catch (e) {
          // 忽略错误，继续执行
          if (done) {
            running--;
            return;
          }
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length && !done) {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
          if (callback != null) {
            Function.apply(callback, [null]);
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