import 'dart:async';

import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('eachOfLimit', () async {
      List<Future> futures = new List();
      futures.add(delayedConstant(1, 100));
      futures.add(delayedConstant(2, 1000));
      futures.add(delayedConstant(3, 2000));
      futures.add(delayedConstant(4, 90));
      futures.add(delayedConstant(5, 200));
      futures.add(delayedConstant(6, 10));
      futures.add(delayedConstant(7, 110));
      futures.add(delayedConstant(8, 2100));
      futures.add(delayedConstant(9, 30));
      futures.add(delayedConstant(10, 10));
      List actual = await eachOfLimit(futures, 3);
      expect(actual, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    });
  });
}
