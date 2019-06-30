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
      functions.add(delayedConstantFunction(false, 100));
      int startTime = DateTime.now().millisecondsSinceEpoch;
      bool actual = await someSeries(functions, (Map<int, bool> result) {
        expect(result, {0: false, 1: false, 2: true});
      });
      int endTime = DateTime.now().millisecondsSinceEpoch;
      expect(actual, true);
      // 如果您debug从此处测试，请把250的数值调整高一些
      expect(endTime - startTime >= 300, true);
    });
  });
}
