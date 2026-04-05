import 'dart:async';
import 'utils.dart';

Future<void> forEachLimit(List<Function> functions, int limit,
    [Function callback]) async {
  Completer<void> completer = new Completer();
  
  // 处理空列表情况
  handleEmptyList(functions, completer, null, callback);
  if (functions.isEmpty) {
    return completer.future;
  }
  
  // 使用并发执行器
  ConcurrentExecutor executor = ConcurrentExecutor(
    functions: functions,
    limit: limit,
    completer: completer,
    callback: callback,
    cancelToken: null,
    returnResult: false,
  );
  
  return executor.start();
}