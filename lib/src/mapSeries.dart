import 'dart:async';
import 'cancel_token.dart';

Future<List> mapSeries(List<Function> functions, [Function callback, CancelToken cancelToken]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List(functions.length);
  Map<int, dynamic> resultMap = new Map();
  Map<int, dynamic> errorMap = new Map();
  int index = 0;
  
  // 处理空列表情况
  if (functions.isEmpty) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
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
    });
  }
  
  mapSeriesImpl(functions, index, tmpResult, resultMap, errorMap, completer, callback, cancelToken);
  return completer.future;
}

void mapSeriesImpl(List<Function> functions, int index, List tmpResult, Map<int, dynamic> resultMap, Map<int, dynamic> errorMap,
    Completer<List> completer, [Function callback, CancelToken cancelToken]) async {
  // 检查是否已取消
  if (cancelToken?.isCancelled ?? false) {
    return;
  }
  
  if (index >= functions.length) {
    if (!completer.isCompleted) {
      completer.complete(tmpResult);
    }
    if (callback != null) {
      Function.apply(callback, [resultMap, errorMap]);
    }
    return;
  }
  
  // 检查是否已取消
  if (cancelToken?.isCancelled ?? false) {
    return;
  }
  
  Function function = functions[index];
  try {
    dynamic result = await function();
    
    // 检查是否已取消
    if (cancelToken?.isCancelled ?? false) {
      return;
    }
    
    tmpResult[index] = result;
    resultMap[index] = result;
  } catch (e) {
    // 记录错误，继续执行
    if (cancelToken?.isCancelled ?? false) {
      return;
    }
    tmpResult[index] = null;
    resultMap[index] = null;
    errorMap[index] = e;
  }
  
  // 检查是否已取消
  if (cancelToken?.isCancelled ?? false) {
    return;
  }
  
  index++;
  mapSeriesImpl(functions, index, tmpResult, resultMap, errorMap, completer, callback, cancelToken);
}

