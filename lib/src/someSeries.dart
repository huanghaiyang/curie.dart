import 'dart:async';

import 'package:curie/src/someLimit.dart';

Future<bool> someSeries(List<Function> functions, [Function callback]) {
  return someLimit(functions, 1, callback);
}
