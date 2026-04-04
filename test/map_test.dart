import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('map test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    List actual = await map(functions);
    expect(actual, [1, 2, 3]);
  });

  test('map with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    Map<int, dynamic> actual;
    await map(functions, (Map<int, dynamic> resultMap, Map<int, dynamic> errorMap) {
      actual = resultMap;
    });
    expect(actual, {0: 1, 1: 2, 2: 3});
  });

  test('map with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    List actual = await map(functions);
    expect(actual, [1, null, 3]);
  });
}
