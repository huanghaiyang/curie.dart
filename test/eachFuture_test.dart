import 'dart:async';

import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('eachSequentially', () async {
      List<Future> futures = new List();
      futures.add(delayedConstant(1, 100));
      futures.add(delayedConstant(2, 100));
      futures.add(delayedConstant(3, 100));
      futures.add(delayedConstant(4, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List actual = await eachFuture(futures);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, [1, 2, 3, 4]);
      expect(endTime - startTime > 100, true);
    });
  });
}
