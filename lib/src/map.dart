import 'dart:async';
import 'cancel_token.dart';
import 'utils.dart';

Future<List> map(List<Function> functions, [Function callback, CancelToken cancelToken]) {
  Completer<List> completer = new Completer();
  List tmpResult = new List(functions.length);
  Map<int, dynamic> resultMap = new Map();
  Map<int, dynamic> errorMap = new Map();
  int completeCounter = 0;
  bool done = false;
  
  // 处理空列表情况
  handleEmptyList(functions, completer, tmpResult, callback, resultMap, errorMap);
  if (functions.isEmpty) {
    return completer.future;
  }
  
  // 监听取消操作
  setupCancelTokenListener(completer, cancelToken, () => done = true);
  
  int incrementCounter() {
    completeCounter++;
    return completeCounter;
  }

  for (int index = 0; index < functions.length; index++) {
    mapImpl(
        functions, index, tmpResult, resultMap, errorMap, completer, incrementCounter, callback, () => done, cancelToken);
  }
  return completer.future;
}

void mapImpl(List<Function> functions, int index, List tmpResult, Map<int, dynamic> resultMap, Map<int, dynamic> errorMap,
    Completer completer, Function incrementCounter, Function callback, Function isDone, CancelToken cancelToken) async {
  // 执行任务
  dynamic result = await executeTask(functions[index], cancelToken, isDone);
  if (cancelToken?.isCancelled ?? false || isDone()) {
    return;
  }
  
  try {
    tmpResult[index] = result;
    resultMap[index] = result;
  } catch (e) {
    tmpResult[index] = null;
    resultMap[index] = null;
    errorMap[index] = e;
  }
  
  // 处理任务完成
  int counter = incrementCounter();
  handleTaskComplete(counter, functions.length, completer, tmpResult, callback, resultMap, errorMap);
}

