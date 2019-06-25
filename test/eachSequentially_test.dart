import 'dart:async';

import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('eachSequentially', () async {
      List<Future> futures = new List();
      int allTime = 1000 + 100 + 20 + 400;
      int startTime = DateTime.now().millisecondsSinceEpoch;
      futures.add(delayedConstant(1, 1000));
      futures.add(delayedConstant(2, 100));
      futures.add(delayedConstant(3, 20));
      futures.add(delayedConstant(4, 400));
      List actual = await eachSequentially(futures);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, [1, 2, 3, 4]);
      expect(allTime >= endTime - startTime, true);
    });
  });
}
