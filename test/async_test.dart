import 'dart:async';

import 'package:curie/curie.dart';
import 'package:test/test.dart';

Future delayed(dynamic value, int timeout) async {
  return Future.delayed(new Duration(milliseconds: timeout), () {
    return value;
  });
}

void main() {
  group('async', () {
    test('eachSequentially', () async {
      List<Future> futures = new List();
      int allTime = 1000 + 100 + 20 + 400;
      int startTime = DateTime.now().millisecondsSinceEpoch;
      futures.add(delayed(1, 1000));
      futures.add(delayed(2, 100));
      futures.add(delayed(3, 20));
      futures.add(delayed(4, 400));
      List actual = await eachSequentially(futures);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, [1, 2, 3, 4]);
      expect(allTime >= endTime - startTime, true);
    });
  });
}
