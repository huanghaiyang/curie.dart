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
      index++;
      if (taskIndex < functions.length) {
        Function task = functions[taskIndex];
        bool value = await task();
        result[taskIndex] = value;
        if (!value) {
          completer.complete(false);
          if (immediateEnd) {
            if (callback != null) {
              Function.apply(callback, [result]);
            }
          }
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        } else {
          if (!looping) {
            execute();
          }
        }
      }
    } else {
      looping = true;
      while (running < limit && !done) {
        execute(index);
      }
    }
  }

  execute();
  return completer.future;
}
