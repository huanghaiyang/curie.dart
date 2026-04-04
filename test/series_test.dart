import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('series test', () async {
    List<Function> functions = [
      delayedConstantFunction('Task 1', 10),
      delayedConstantFunction('Task 2', 10),
      delayedConstantFunction('Task 3', 10)
    ];

    List actual = await series(functions);
    expect(actual, ['Task 1', 'Task 2', 'Task 3']);
  });

  test('series with callback test', () async {
    List<Function> functions = [
      delayedConstantFunction('Task 1', 10),
      delayedConstantFunction('Task 2', 10),
      delayedConstantFunction('Task 3', 10)
    ];

    List actual;
    await series(functions, (result) {
      actual = result;
    });
    expect(actual, ['Task 1', 'Task 2', 'Task 3']);
  });

  test('series with error test', () async {
    List<Function> functions = [
      delayedConstantFunction('Task 1', 10),
      () async {
        throw Exception('error');
      },
      delayedConstantFunction('Task 3', 10)
    ];

    List actual = await series(functions);
    expect(actual, ['Task 1', null, 'Task 3']);
  });
}
