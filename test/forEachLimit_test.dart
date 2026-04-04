import 'dart:async';
import 'package:test/test.dart';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';

void main() {
  test('forEachLimit test', () async {
    List<String> results = [];
    List<Function> functions = [
      () async {
        await delayedConstant('Task 1', 10);
        results.add('Task 1');
      },
      () async {
        await delayedConstant('Task 2', 10);
        results.add('Task 2');
      },
      () async {
        await delayedConstant('Task 3', 10);
        results.add('Task 3');
      }
    ];

    await forEachLimit(functions, 2);
    expect(results, ['Task 1', 'Task 2', 'Task 3']);
  });

  test('forEachLimit with callback test', () async {
    List<String> results = [];
    bool callbackCalled = false;
    List<Function> functions = [
      () async {
        await delayedConstant('Task 1', 10);
        results.add('Task 1');
      },
      () async {
        await delayedConstant('Task 2', 10);
        results.add('Task 2');
      },
      () async {
        await delayedConstant('Task 3', 10);
        results.add('Task 3');
      }
    ];

    await forEachLimit(functions, 2, () {
      callbackCalled = true;
    });
    expect(results, ['Task 1', 'Task 2', 'Task 3']);
    expect(callbackCalled, true);
  });

  test('forEachLimit with error test', () async {
    List<String> results = [];
    List<Function> functions = [
      () async {
        await delayedConstant('Task 1', 10);
        results.add('Task 1');
      },
      () async {
        throw Exception('error');
      },
      () async {
        await delayedConstant('Task 3', 10);
        results.add('Task 3');
      }
    ];

    await forEachLimit(functions, 2);
    expect(results, ['Task 1', 'Task 3']);
  });
}
