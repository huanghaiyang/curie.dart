import 'dart:async';
import 'utils.dart';

Future<void> forEachSeries(List<Function> functions, [Function callback]) {
  Completer<void> completer = new Completer();
  
  // 处理空列表情况
  handleEmptyList(functions, completer, null, callback);
  if (functions.isEmpty) {
    return completer.future;
  }
  
  // 使用串行执行器
  SeriesExecutor executor = SeriesExecutor(
    functions: functions,
    completer: completer,
    callback: callback,
    cancelToken: null,
    returnResult: false,
  );
  
  return executor.start();
}