import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('every true', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await everySeries(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, true);
      expect(endTime - startTime >= 400, true);
    });
  });
}
