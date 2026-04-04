import 'dart:async';

Future<dynamic> waterfall(List<Function> functions) async {
  if (functions.isEmpty) {
    return null;
  }
  dynamic preResult;
  for (int i = 0; i < functions.length; i++) {
    Function function = functions[i];
    try {
      preResult = await Function.apply(function, [preResult]);
    } catch (e) {
      // 忽略错误，继续执行
      preResult = null;
    }
  }
  return preResult;
}
