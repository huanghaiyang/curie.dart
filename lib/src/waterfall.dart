Future<dynamic> waterfall(List<Function> functions) async {
  dynamic preResult;
  for (int i = 0; i < functions.length; i++) {
    Function function = functions[i];
    preResult = await Function.apply(function, [preResult]);
  }
  return preResult;
}
