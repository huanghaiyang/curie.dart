Future delayedConstant(dynamic value, int timeout) async {
  return Future.delayed(new Duration(milliseconds: timeout), () {
    return value;
  });
}

Function delayedConstantFunction(dynamic value, int timeout) {
  return () async {
    return await Future.delayed(new Duration(milliseconds: timeout), () {
      return value;
    });
  };
}

Function delayedSum(int value, timeout) {
  return ([int preResult]) async {
    int curr = await Future.delayed(new Duration(milliseconds: timeout), () {
      return value;
    });
    return curr + (preResult == null ? 0 : preResult);
  };
}
