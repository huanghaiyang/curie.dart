import 'dart:async';

import 'package:curie/src/everyLimit.dart';

Future<bool> everySeries(List<Function> functions, [Function callback]) {
  return everyLimit(functions, 1, callback);
}
