import 'dart:async';
import 'cancel_token.dart';

Future<List> filterLimit(List<Function> functions, Function predicate, int limit, [Function callback, CancelToken cancelToken]) async {
  Completer<List> completer = new Completer();
  List result = new List();
  Map<int, dynamic> resultMap = new Map();
  Map<int, dynamic> errorMap = new Map();
  bool done = false;
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool looping = false;
  
  // 处理空列表情况
  if (functions.isEmpty) {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
    if (callback != null) {
      Function.apply(callback, [resultMap, errorMap]);
    }
    return completer.future;
  }
  
  // 监听取消操作
  if (cancelToken != null) {
    cancelToken.whenCancelled.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(CancelException('Operation cancelled'));
      }
      done = true;
    });
  }
  void execute([int currIndex]) async {
    if (completer.isCompleted || (cancelToken?.isCancelled ?? false)) {
      return;
    }
    if (currIndex != null) {
      running++;
      int taskIndex = currIndex;
      if (taskIndex < functions.length && !done && !(cancelToken?.isCancelled ?? false)) {
        Function task = functions[taskIndex];
        try {
          dynamic value = await task();
          if (done || (cancelToken?.isCancelled ?? false)) {
            running--;
            return;
          }
          bool shouldInclude = await predicate(value);
          if (done || (cancelToken?.isCancelled ?? false)) {
            running--;
            return;
          }
          resultMap[taskIndex] = shouldInclude ? value : null;
          if (shouldInclude) {
            result.add(value);
          }
        } catch (e) {
          // 记录错误，继续执行
          if (done || (cancelToken?.isCancelled ?? false)) {
            running--;
            return;
          }
          resultMap[taskIndex] = null;
          errorMap[taskIndex] = e;
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
            Function.apply(callback, [resultMap, errorMap]);
          }
        } else if (!done && !(cancelToken?.isCancelled ?? false)) {
          if (!looping) {
            execute();
          }
        }
      } else {
        running--;
      }
    } else {
      looping = true;
      while (running < limit && !done && index < functions.length && !(cancelToken?.isCancelled ?? false)) {
        int currentIndex = index;
        index++;
        execute(currentIndex);
      }
    }
  }

  execute();
  return completer.future;
}

