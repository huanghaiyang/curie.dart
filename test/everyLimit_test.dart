import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('every true', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 200));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await everyLimit(functions, 2);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, true);
      expect(endTime - startTime >= 300, true);
    });

    test('return false', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 200));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(true, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await everyLimit(functions, 2, (Map<int, bool> result) {
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(result, {0: true, 1: true, 2: false});
        expect(endTime - startTime >= 200 && endTime - startTime < 250, true);
      });
      expect(actual, false);
    });

    test('return false', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(true, 200));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(true, 200));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await everyLimit(functions, 2, (Map<int, bool> result) {
        expect(result, {0: true, 1: true, 2: false, 3: true});
      }, false);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, false);
      expect(endTime - startTime >= 200 && endTime - startTime < 250, true);
    });
  });
}
