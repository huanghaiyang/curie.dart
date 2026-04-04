import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('mapSeries test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    List actual = await mapSeries(functions);
    expect(actual, [1, 2, 3]);
  });

  test('mapSeries with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      delayedConstantFunction(2, 10),
      delayedConstantFunction(3, 10)
    ];

    List actual;
    await mapSeries(functions, (result) {
      actual = result;
    });
    expect(actual, [1, 2, 3]);
  });

  test('mapSeries with error test', () async {
    List<Function> functions = [
      delayedConstantFunction(1, 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction(3, 10)
    ];

    List actual = await mapSeries(functions);
    expect(actual, [1, null, 3]);
  });
}
