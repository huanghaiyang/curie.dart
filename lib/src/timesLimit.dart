import 'dart:async';

Future<List> timesLimit(Function function, int times, int limit,
    [Function callback]) async {
  Completer<List> completer = new Completer();
  List result = new List(times);
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  void execute([int currIndex]) async {
    if (currIndex != null) {
      running++;
      int taskIndex = currIndex;
      if (taskIndex < times && !done) {
        try {
          dynamic value = await function();
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
        if (completeCount == times) {
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
      while (running < limit && !done && index < times) {
        int currentIndex = index;
        index++;
        execute(currentIndex);
      }
    }
  }

  execute();
  return completer.future;
}
