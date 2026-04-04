import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('filter test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10),
      delayedConstantFunction(4, 10),
      delayedConstantFunction(5, 10)
    ];

    List actual = await filter(functions, (value) async => value > 2);
    expect(actual, [3, 4, 5]);
  });

  test('filter with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    Map<int, dynamic> actual;
    await filter(functions, (value) async => value > 1, (Map<int, dynamic> resultMap, Map<int, dynamic> errorMap) {
      actual = resultMap;
    });
    expect(actual, {0: null, 1: 2, 2: 3});
  });

  test('filter with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    List actual = await filter(functions, (value) async => value > 1);
    expect(actual, [3]);
  });
}
