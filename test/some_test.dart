import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('some true', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(true, 100));
      functions.add(delayedConstantFunction(false, 200));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await some(functions, (List<bool> result) {
        expect(result, [false, false, true, false]);
      });
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, true);
      expect(endTime - startTime >= 100 && endTime - startTime < 200, true);
    });

    test('some false', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 100));
      functions.add(delayedConstantFunction(false, 200));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await some(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, false);
      expect(endTime - startTime >= 200, true);
    });
  });
}
