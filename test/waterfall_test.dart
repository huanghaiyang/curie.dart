import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('waterfall', () {
    test('waterfall sum', () async {
      List<Function> functions = new List();
      for (int i = 1; i <= 10; i++) {
        functions.add(delayedSum(i, 100));
      }
      int startTime = DateTime.now().millisecondsSinceEpoch;
      dynamic actual = await waterfall(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, 55);
      expect(endTime - startTime >= 100 * 10, true);
    });
  });
}
