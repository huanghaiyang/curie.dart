import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('async', () {
    test('eachOfLimit', () async {
      List<Function> functions = new List();
      functions.add(delayedConstantFunction(1, 100));
      functions.add(delayedConstantFunction(2, 1000));
      functions.add(delayedConstantFunction(3, 2000));
      functions.add(delayedConstantFunction(4, 90));
      functions.add(delayedConstantFunction(5, 200));
      functions.add(delayedConstantFunction(6, 10));
      functions.add(delayedConstantFunction(7, 110));
      functions.add(delayedConstantFunction(8, 2100));
      functions.add(delayedConstantFunction(9, 30));
      functions.add(delayedConstantFunction(10, 10));
      List actual = await eachLimit(functions, 3, (
          [int index, int running, int completeCount, bool done, List result]) {
        print(
            (index).toString() + ' : ' + result[result.length - 1].toString());
      });
      expect(actual, [1, 4, 5, 6, 7, 2, 9, 10, 3, 8]);
    });
  });
}
