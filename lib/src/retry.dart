import 'dart:async';

Future retry(Function function, int times, Function interval,
    [Function callback]) async {
  Completer completer = new Completer();
  List errorList = new List();
  retryImpl(function, times, interval, errorList, completer, callback);
  return completer.future;
}

void retryImpl(Function function, int times, Function interval, List errorList,
    Completer completer,
    [Function callback]) async {
  if (times == 0) {
    if (callback != null) {
      Function.apply(callback, [errorList, null]);
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    return;
  }
  try {
    dynamic result = await function();
    if (callback != null) {
      Function.apply(callback, [errorList, result]);
    }
    completer.complete(result);
  } catch (error) {
    errorList.add(error);
    int intervalTime = await interval();
    if (times > 0) {
      Future.delayed(
          new Duration(milliseconds: intervalTime),
          () => retryImpl(
              function, times - 1, interval, errorList, completer, callback));
    }
  }
}
