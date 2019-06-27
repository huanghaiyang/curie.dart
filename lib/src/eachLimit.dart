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
      index++;
      if (taskIndex < functions.length) {
        Function task = functions[taskIndex];
        dynamic value = await task();
        result.add(value);
        if (eachCallback != null) {
          eachCallback(taskIndex, running, completeCount, done, result);
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          completer.complete(result);
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
