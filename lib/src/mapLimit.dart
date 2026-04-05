import 'dart:async';
import 'cancel_token.dart';
import 'utils.dart';

Future<List> mapLimit(List<Function> functions, int limit, [Function callback, CancelToken cancelToken]) async {
  Completer<List> completer = new Completer();
  
  // 处理空列表情况
  handleEmptyList(functions, completer, List(functions.length), callback, Map<int, dynamic>(), Map<int, dynamic>());
  if (functions.isEmpty) {
    return completer.future;
  }
  
  // 使用并发执行器
  ConcurrentExecutor executor = ConcurrentExecutor(
    functions: functions,
    limit: limit,
    completer: completer,
    callback: callback,
    cancelToken: cancelToken,
    returnResult: true,
  );
  
  return executor.start();
}

