import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('reduce test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    dynamic actual = await reduce(functions, (acc, value) => acc + value, 0);
    expect(actual, 6);
  });

  test('reduce with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    dynamic actual;
    await reduce(functions, (acc, value) => acc + value, 0, (result) {
      actual = result;
    });
    expect(actual, 6);
  });

  test('reduce with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    dynamic actual = await reduce(functions, (acc, value) => acc + value, 0);
    expect(actual, 4);
  });
}
