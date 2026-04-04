import 'dart:async';

Future<List> eachLimit(List<Function> functions, int limit,
    [void eachCallback(
        [int index,
        int running,
        int completeCount,
        bool done,
        List result])]) async {
  Completer<List> completer = new Completer<List>();
  List result = new List();
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  void execute([int currIndex]) async {
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
          result.add(value);
          running--;
          completeCount++;
          if (eachCallback != null) {
            eachCallback(taskIndex, running, completeCount, done, result);
          }
          looping = false;
          if (completeCount == functions.length) {
            done = true;
            completer.complete(result);
          } else if (!done) {
            if (!looping) {
              execute();
            }
          }
        } catch (e) {
          // 忽略错误，继续执行
          running--;
          completeCount++;
          looping = false;
          if (completeCount == functions.length) {
            done = true;
            completer.complete(result);
          } else if (!done) {
            if (!looping) {
              execute();
            }
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
