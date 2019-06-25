Future delayedConstant(dynamic value, int timeout) async {
  return Future.delayed(new Duration(milliseconds: timeout), () {
    return value;
  });
}
