import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('timesSeries', () async {
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result =
          await timesSeries(delayedConstantFunction(1, 100), 10, (List actual) {
        expect(actual, List.filled(10, 1));
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(endTime - startTime >= 100 * 10, true);
      });
      expect(result, List.filled(10, 1));
    });
  });
}
