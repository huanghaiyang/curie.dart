import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('timesLimit', () async {
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await timesLimit(delayedConstantFunction(1, 100), 10, 2,
          (List actual) {
        expect(actual, List.filled(10, 1));
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(
            endTime - startTime >= 100 * 5 &&
                endTime - startTime < 100 * 5 + 50,
            true);
      });
      expect(result, List.filled(10, 1));
    });
  });
}
