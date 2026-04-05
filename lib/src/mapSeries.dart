import 'dart:async';
import 'cancel_token.dart';
import 'utils.dart';

Future<List> mapSeries(List<Function> functions, [Function callback, CancelToken cancelToken]) {
  Completer<List> completer = new Completer();
  
  // 处理空列表情况
  handleEmptyList(functions, completer, List(functions.length), callback, Map<int, dynamic>(), Map<int, dynamic>());
  if (functions.isEmpty) {
    return completer.future;
  }
  
  // 使用串行执行器
  SeriesExecutor executor = SeriesExecutor(
    functions: functions,
    completer: completer,
    callback: callback,
    cancelToken: cancelToken,
    returnResult: true,
  );
  
  return executor.start();
}

