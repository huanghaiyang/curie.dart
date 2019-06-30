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
      index++;
      if (taskIndex < times) {
        dynamic value = await function();
        result[taskIndex] = value;
        running--;
        completeCount++;
        looping = false;
        if (completeCount == times) {
          done = true;
          completer.complete(result);
          if (callback != null) {
            Function.apply(callback, [result]);
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
