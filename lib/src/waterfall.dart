Future<dynamic> waterfall(List<Function> functions) async {
  dynamic preResult;
  List<int> list = List();
  for (int i = 0; i < functions.length; i++) {
    list.add(i);
  }
  await for (int i in Stream.fromIterable(list)) {
    Function function = functions[i];
    preResult = await Function.apply(function, [preResult]);
  }
  return preResult;
}
