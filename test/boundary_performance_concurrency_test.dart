import 'dart:async';
import 'dart:math';
import 'package:curie/curie.dart';
import 'package:curie/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('边界情况测试', () {
    test('空列表测试', () async {
      List<Function> emptyFunctions = [];
      
      // 测试 map
      List mapResult = await map(emptyFunctions);
      expect(mapResult, []);
      
      // 测试 filter
      List filterResult = await filter(emptyFunctions, (value) async => value > 0);
      expect(filterResult, []);
      
      // 测试 every
      bool everyResult = await every(emptyFunctions);
      expect(everyResult, true);
      
      // 测试 some
      bool someResult = await some(emptyFunctions);
      expect(someResult, false);
      
      // 测试 forEach
      await forEach(emptyFunctions);
    });

    test('错误处理测试', () async {
      List<Function> functions = [
        delayedConstantFunction(1, 10),
        () async {
          throw Exception('测试错误');
        },
        delayedConstantFunction(3, 10)
      ];
      
      // 测试 map 错误处理
      List mapResult = await map(functions);
      expect(mapResult, [1, null, 3]);
      
      // 测试 filter 错误处理
      List filterResult = await filter(functions, (value) async => value > 1);
      expect(filterResult, [3]);
      
      // 测试 forEach 错误处理
      List<String> forEachResults = [];
      await forEach(functions, () {
        forEachResults.add('callback');
      });
      expect(forEachResults.length, 1);
    });

    test('超时测试', () async {
      List<Function> functions = [
        () async {
          await Future.delayed(Duration(milliseconds: 50));
          return 1;
        },
        () async {
          await Future.delayed(Duration(milliseconds: 100));
          return 2;
        }
      ];
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await map(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result, [1, 2]);
      expect(endTime - startTime >= 100, true);
    });
  });

  group('性能测试', () {
    test('小规模任务测试', () async {
      int taskCount = 10;
      List<Function> functions = List.generate(taskCount, (index) {
        return delayedConstantFunction(index, 1);
      });
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await map(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result.length, taskCount);
      print('小规模任务（$taskCount 个）执行时间：${endTime - startTime}ms');
    });

    test('中等规模任务测试', () async {
      int taskCount = 100;
      List<Function> functions = List.generate(taskCount, (index) {
        return delayedConstantFunction(index, 1);
      });
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await map(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result.length, taskCount);
      print('中等规模任务（$taskCount 个）执行时间：${endTime - startTime}ms');
    });

    test('大规模任务测试', () async {
      int taskCount = 1000;
      List<Function> functions = List.generate(taskCount, (index) {
        return delayedConstantFunction(index, 1);
      });
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await map(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result.length, taskCount);
      print('大规模任务（$taskCount 个）执行时间：${endTime - startTime}ms');
    });

    test('并发限制性能测试', () async {
      int taskCount = 100;
      int limit = 10;
      List<Function> functions = List.generate(taskCount, (index) {
        return delayedConstantFunction(index, 10);
      });
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await mapLimit(functions, limit);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result.length, taskCount);
      print('并发限制（$limit）任务（$taskCount 个）执行时间：${endTime - startTime}ms');
    });
  });

  group('并发场景测试', () {
    test('高并发任务测试', () async {
      int taskCount = 100;
      List<Function> functions = List.generate(taskCount, (index) {
        return () async {
          // 模拟不同的执行时间
          int delay = Random().nextInt(50) + 10;
          await Future.delayed(Duration(milliseconds: delay));
          return index;
        };
      });
      
      List result = await map(functions);
      expect(result.length, taskCount);
      // 验证所有任务都执行了
      for (int i = 0; i < taskCount; i++) {
        expect(result.contains(i), true);
      }
    });

    test('并发限制场景测试', () async {
      int taskCount = 20;
      int limit = 5;
      int runningCount = 0;
      int maxRunningCount = 0;
      
      List<Function> functions = List.generate(taskCount, (index) {
        return () async {
          runningCount++;
          if (runningCount > maxRunningCount) {
            maxRunningCount = runningCount;
          }
          await Future.delayed(Duration(milliseconds: 50));
          runningCount--;
          return index;
        };
      });
      
      List result = await mapLimit(functions, limit);
      expect(result.length, taskCount);
      // 验证并发数不超过限制
      expect(maxRunningCount <= limit, true);
      print('最大并发数：$maxRunningCount，限制：$limit');
    });

    test('混合任务类型并发测试', () async {
      List<Function> functions = [
        // 快速任务
        delayedConstantFunction('fast1', 10),
        delayedConstantFunction('fast2', 10),
        // 慢速任务
        delayedConstantFunction('slow1', 100),
        delayedConstantFunction('slow2', 100),
        // 中等速度任务
        delayedConstantFunction('medium1', 50),
        delayedConstantFunction('medium2', 50),
      ];
      
      int startTime = DateTime.now().millisecondsSinceEpoch;
      List result = await map(functions);
      int endTime = DateTime.now().millisecondsSinceEpoch;
      
      expect(result.length, functions.length);
      print('混合任务执行时间：${endTime - startTime}ms');
    });
  });
}
