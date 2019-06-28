import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('some true immediate end', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 200));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(false, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await someLimit(functions, 2, (Map<int, bool> result) {
        expect(result, {0: false, 1: false, 2: true});
      });
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, true);
      // 如果您debug从此处测试，请把250的数值调整高一些
      expect(endTime - startTime >= 200 && endTime - startTime < 250, true);
    });

    test('some true util end', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 200));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(false, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await someLimit(functions, 2, (Map<int, bool> result) {
        int endTime = DateTime.now().millisecondsSinceEpoch;
        expect(result, {0: false, 1: false, 2: true, 3: false});
        expect(endTime - startTime >= 300 && endTime - startTime < 350, true);
      }, false);
      expect(actual, true);
    });

    test('some false', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 200));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 200));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await someLimit(functions, 2, (Map<int, bool> result) {
        expect(result, {0: false, 1: false, 2: false, 3: false});
      });
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, false);
      expect(endTime - startTime >= 400 && endTime - startTime < 410, true);
    });
  });
}
