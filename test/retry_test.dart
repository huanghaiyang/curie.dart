import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('retry', () async {
      int startTime = DateTime.now().millisecondsSinceEpoch;
      dynamic result = await retry(
          delayedConstantFunctionWhenError(
              1, 100, [0, 1, 2], new Exception("custom error")),
          4,
          () => 100, (List actual, dynamic result) {
        expect(actual.length, 3);
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(endTime - startTime >= 700 && endTime - startTime < 800, true);
      });
      expect(result, 1);
    });

    test('retry', () async {
      int startTime = DateTime.now().millisecondsSinceEpoch;
      dynamic result = await retry(
          delayedConstantFunctionWhenError(
              1, 100, [0, 1, 2, 3], new Exception("custom error")),
          4,
          () => 100, (List actual, dynamic result) {
        expect(actual.length, 4);
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(endTime - startTime >= 800 && endTime - startTime < 900, true);
      });
      expect(result, null);
    });
  });
}
