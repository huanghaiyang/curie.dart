import 'dart:async';
import 'cancel_token.dart';

Future delayedConstant(dynamic value, int timeout) async {
  return Future.delayed(new Duration(milliseconds: timeout), () {
    return value;
  });
}

Function delayedConstantFunction(dynamic value, int timeout) {
  return () async {
    return await Future.delayed(new Duration(milliseconds: timeout), () {
      return value;
    });
  };
}

Function delayedConstantFunctionWhenError(
    dynamic value, int timeout, List<int> errorIndex, Exception error) {
  int index = 0;
  return () async {
    return await Future.delayed(new Duration(milliseconds: timeout), () {
      if (errorIndex.contains(index)) {
        index++;
        throw error;
      } else {
        index++;
        return value;
      }
    });
  };
}

Function delayedSum(int value, timeout) {
  return ([int preResult]) async {
    int curr = await Future.delayed(new Duration(milliseconds: timeout), () {
      return value;
    });
    return curr + (preResult == null ? 0 : preResult);
  };
}

/// 检查是否为空列表，如果是则完成 completer 并调用回调
void handleEmptyList<T>(List<Function> functions, Completer<T> completer, T defaultValue, [Function callback, Map<int, dynamic> resultMap, Map<int, dynamic> errorMap]) {
  if (functions.isEmpty) {
    if (!completer.isCompleted) {
      completer.complete(defaultValue);
    }
    if (callback != null) {
      if (resultMap != null && errorMap != null) {
        Function.apply(callback, [resultMap, errorMap]);
      } else {
        Function.apply(callback, []);
      }
    }
  }
}

/// 监听取消操作
void setupCancelTokenListener(Completer completer, CancelToken cancelToken, Function setDone) {
  if (cancelToken != null) {
    cancelToken.whenCancelled.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(CancelException('Operation cancelled'));
      }
      setDone();
    });
  }
}

/// 执行单个任务并处理错误
Future<dynamic> executeTask(Function task, CancelToken cancelToken, bool Function() isDone) async {
  if (cancelToken?.isCancelled ?? false || isDone()) {
    return null;
  }
  try {
    dynamic result = await task();
    if (cancelToken?.isCancelled ?? false || isDone()) {
      return null;
    }
    return result;
  } catch (e) {
    if (cancelToken?.isCancelled ?? false || isDone()) {
      return null;
    }
    return null;
  }
}

/// 处理任务完成后的逻辑
void handleTaskComplete<T>(int completeCount, int totalCount, Completer<T> completer, T result, [Function callback, Map<int, dynamic> resultMap, Map<int, dynamic> errorMap]) {
  if (completeCount == totalCount) {
    if (!completer.isCompleted) {
      completer.complete(result);
    }
    if (callback != null) {
      if (resultMap != null && errorMap != null) {
        Function.apply(callback, [resultMap, errorMap]);
      } else {
        Function.apply(callback, []);
      }
    }
  }
}

/// 并发控制执行器
class ConcurrentExecutor {
  final List<Function> functions;
  final int limit;
  final Completer completer;
  final Function callback;
  final CancelToken cancelToken;
  
  int running = 0;
  int index = 0;
  int completeCount = 0;
  bool done = false;
  bool looping = false;
  final List result;
  final Map<int, dynamic> resultMap;
  final Map<int, dynamic> errorMap;
  final bool returnResult;
  
  ConcurrentExecutor({
    this.functions,
    this.limit,
    this.completer,
    this.callback,
    this.cancelToken,
    this.returnResult = true,
  }) : result = returnResult ? List(functions.length) : null,
       resultMap = returnResult ? Map<int, dynamic>() : null,
       errorMap = returnResult ? Map<int, dynamic>() : null;
  
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
          if (returnResult) {
            resultMap[taskIndex] = value;
            result[taskIndex] = value;
          }
        } catch (e) {
          // 记录错误，继续执行
          if (done || (cancelToken?.isCancelled ?? false)) {
            running--;
            return;
          }
          if (returnResult) {
            resultMap[taskIndex] = null;
            result[taskIndex] = null;
            errorMap[taskIndex] = e;
          }
        }
        running--;
        completeCount++;
        looping = false;
        if (completeCount == functions.length) {
          done = true;
          if (!completer.isCompleted) {
            completer.complete(returnResult ? result : null);
          }
          if (callback != null) {
            if (returnResult) {
              Function.apply(callback, [resultMap, errorMap]);
            } else {
              Function.apply(callback, []);
            }
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
  
  Future start() {
    execute();
    return completer.future;
  }
}

/// 串行执行器
class SeriesExecutor {
  final List<Function> functions;
  final Completer completer;
  final Function callback;
  final CancelToken cancelToken;
  
  int index = 0;
  final List result;
  final Map<int, dynamic> resultMap;
  final Map<int, dynamic> errorMap;
  final bool returnResult;
  
  SeriesExecutor({
    this.functions,
    this.completer,
    this.callback,
    this.cancelToken,
    this.returnResult = true,
  }) : result = returnResult ? List(functions.length) : null,
       resultMap = returnResult ? Map<int, dynamic>() : null,
       errorMap = returnResult ? Map<int, dynamic>() : null;
  
  Future<void> execute() async {
    if (index >= functions.length) {
      if (!completer.isCompleted) {
        completer.complete(returnResult ? result : null);
      }
      if (callback != null) {
        if (returnResult) {
          Function.apply(callback, [resultMap, errorMap]);
        } else {
          Function.apply(callback, []);
        }
      }
      return;
    }
    
    // 检查是否已取消
    if (cancelToken?.isCancelled ?? false) {
      return;
    }
    
    Function function = functions[index];
    try {
      dynamic functionResult = await function();
      
      // 检查是否已取消
      if (cancelToken?.isCancelled ?? false) {
        return;
      }
      
      if (returnResult) {
        result[index] = functionResult;
        resultMap[index] = functionResult;
      }
    } catch (e) {
      // 记录错误，继续执行
      if (cancelToken?.isCancelled ?? false) {
        return;
      }
      if (returnResult) {
        result[index] = null;
        resultMap[index] = null;
        errorMap[index] = e;
      }
    }
    
    // 检查是否已取消
    if (cancelToken?.isCancelled ?? false) {
      return;
    }
    
    index++;
    await execute();
  }
  
  Future start() {
    execute();
    return completer.future;
  }
}
