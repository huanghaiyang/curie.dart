import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('detectLimit test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10),
      delayedConstantFunction(4, 10),
      delayedConstantFunction(5, 10)
    ];

    dynamic actual = await detectLimit(functions, (value) async => value > 2, 2);
    expect(actual, 3);
  });

  test('detectLimit with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    dynamic actual;
    await detectLimit(functions, (value) async => value > 1, 2, (result) {
      actual = result;
    });
    expect(actual, 2);
  });

  test('detectLimit with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    dynamic actual = await detectLimit(functions, (value) async => value > 1, 2);
    expect(actual, 3);
  });

  test('detectLimit with no match test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    dynamic actual = await detectLimit(functions, (value) async => value > 3, 2);
    expect(actual, null);
  });
}
