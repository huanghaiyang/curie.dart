import 'dart:async';

Future<List> eachOfLimit(List<Future> futures, int limit,
    [Function eachCallback]) async {
  Completer<List> completer = new Completer<List>();
  List result = new List(futures.length);
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  void execute() {
    looping = true;
    while (running < limit && !done) {
      running++;
      int taskIndex = index;
      index++;
      if (taskIndex < futures.length) {
        Future task = futures[taskIndex];
        task.then((value) {
          result[taskIndex] = value;
        }).catchError((error) {
          result[taskIndex] = error;
        }).whenComplete(() {
          if (eachCallback != null) {
            eachCallback(taskIndex, running, completeCount, done, result);
          }
          running--;
          completeCount++;
          looping = false;
          if (completeCount == futures.length) {
            done = true;
            completer.complete(result);
          } else {
            if (!looping) {
              execute();
            }
          }
        });
      }
    }
  }

  execute();
  return completer.future;
}
