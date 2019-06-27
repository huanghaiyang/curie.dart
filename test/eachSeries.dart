import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('eachSequentially', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(1, 100));
      functions.add(delayedConstantFunction(2, 100));
      functions.add(delayedConstantFunction(3, 100));
      functions.add(delayedConstantFunction(4, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List actual = await eachSeries(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, [1, 2, 3, 4]);
      expect(endTime - startTime > 100 * 4, true);
    });
  });
}
