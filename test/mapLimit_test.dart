import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('mapLimit test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10),
      delayedConstantFunction(4, 10),
      delayedConstantFunction(5, 10)
    ];

    List actual = await mapLimit(functions, 2);
    expect(actual, [1, 2, 3, 4, 5]);
  });

  test('mapLimit with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    List actual;
    await mapLimit(functions, 2, (result) {
      actual = result;
    });
    expect(actual, [1, 2, 3]);
  });

  test('mapLimit with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    List actual = await mapLimit(functions, 2);
    expect(actual, [1, null, 3]);
  });
}
