## Curie - Dart 异步函数库

Curie 是一个功能强大的 Dart 异步函数库，提供了丰富的异步操作工具，帮助开发者更优雅地处理异步任务。

### 特性

- **函数优先**：以函数为中心的设计理念，简洁易用
- **丰富的异步工具**：提供多种异步执行模式，满足不同场景需求
- **错误处理**：内置错误处理机制，确保程序稳定运行
- **并发控制**：支持限制并发数，避免资源耗尽
- **类型安全**：完整的类型定义，提供良好的开发体验

### 安装

在 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  curie: ^1.0.0
```

然后运行 `pub get` 安装依赖。

### 使用示例

#### 1. eachSeries - 串行执行函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 'Task 1',
    () async => 'Task 2',
    () async => 'Task 3'
  ];
  
  List results = await eachSeries(functions);
  print(results); // 输出: [Task 1, Task 2, Task 3]
}
```

#### 2. eachLimit - 限制并发数执行函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 'Task 1',
    () async => 'Task 2',
    () async => 'Task 3',
    () async => 'Task 4',
    () async => 'Task 5'
  ];
  
  List results = await eachLimit(functions, 2);
  print(results); // 输出: [Task 1, Task 2, Task 3, Task 4, Task 5]
}
```

#### 3. waterfall - 瀑布流执行函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    (prev) async => prev ?? 1,
    (prev) async => prev * 2,
    (prev) async => prev + 3
  ];
  
  dynamic result = await waterfall(functions);
  print(result); // 输出: 5
}
```

#### 4. some - 并行执行函数列表，只要有一个返回 true 就立即返回

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => false,
    () async => true,
    () async => false
  ];
  
  bool result = await some(functions);
  print(result); // 输出: true
}
```

#### 5. someLimit - 限制并发数执行函数列表，只要有一个返回 true 就立即返回

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => false,
    () async => true,
    () async => false,
    () async => false
  ];
  
  bool result = await someLimit(functions, 2);
  print(result); // 输出: true
}
```

#### 6. someSeries - 串行执行函数列表，只要有一个返回 true 就立即返回

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => false,
    () async => true,
    () async => false
  ];
  
  bool result = await someSeries(functions);
  print(result); // 输出: true
}
```

#### 7. every - 并行执行函数列表，所有函数都返回 true 才返回 true

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => true,
    () async => true,
    () async => true
  ];
  
  bool result = await every(functions);
  print(result); // 输出: true
}
```

#### 8. everyLimit - 限制并发数执行函数列表，所有函数都返回 true 才返回 true

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => true,
    () async => true,
    () async => true,
    () async => true
  ];
  
  bool result = await everyLimit(functions, 2);
  print(result); // 输出: true
}
```

#### 9. everySeries - 串行执行函数列表，所有函数都返回 true 才返回 true

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => true,
    () async => true,
    () async => true
  ];
  
  bool result = await everySeries(functions);
  print(result); // 输出: true
}
```

#### 10. times - 并行执行函数指定次数

```dart
import 'package:curie/curie.dart';

void main() async {
  int count = 0;
  List results = await times(() async => ++count, 5);
  print(results); // 输出: [1, 2, 3, 4, 5]
}
```

#### 11. timesSeries - 串行执行函数指定次数

```dart
import 'package:curie/curie.dart';

void main() async {
  int count = 0;
  List results = await timesSeries(() async => ++count, 5);
  print(results); // 输出: [1, 2, 3, 4, 5]
}
```

#### 12. timesLimit - 限制并发数执行函数指定次数

```dart
import 'package:curie/curie.dart';

void main() async {
  int count = 0;
  List results = await timesLimit(() async => ++count, 5, 2);
  print(results); // 输出: [1, 2, 3, 4, 5]
}
```

#### 13. retry - 重试函数执行

```dart
import 'package:curie/curie.dart';

void main() async {
  int attempts = 0;
  dynamic result = await retry(
    () async {
      attempts++;
      if (attempts < 3) {
        throw Exception('Failed');
      }
      return 'Success';
    },
    3,
    () => 100 // 每次重试间隔 100 毫秒
  );
  print(result); // 输出: Success
}
```

#### 14. map - 并行执行函数列表，返回所有结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3
  ];
  
  List results = await map(functions);
  print(results); // 输出: [1, 2, 3]
}
```

#### 15. mapLimit - 限制并发数执行函数列表，返回所有结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  List results = await mapLimit(functions, 2);
  print(results); // 输出: [1, 2, 3, 4, 5]
}
```

#### 16. mapSeries - 串行执行函数列表，返回所有结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3
  ];
  
  List results = await mapSeries(functions);
  print(results); // 输出: [1, 2, 3]
}
```

#### 17. filter - 并行执行函数列表，过滤出满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  List results = await filter(functions, (value) async => value > 2);
  print(results); // 输出: [3, 4, 5]
}
```

#### 18. filterLimit - 限制并发数执行函数列表，过滤出满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  List results = await filterLimit(functions, (value) async => value > 2, 2);
  print(results); // 输出: [3, 4, 5]
}
```

#### 19. filterSeries - 串行执行函数列表，过滤出满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  List results = await filterSeries(functions, (value) async => value > 2);
  print(results); // 输出: [3, 4, 5]
}
```

#### 20. reduce - 将函数列表的结果累加到一个值

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3
  ];
  
  dynamic result = await reduce(functions, (acc, value) => acc + value, 0);
  print(result); // 输出: 6
}
```

#### 21. detect - 并行执行函数列表，找到第一个满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  dynamic result = await detect(functions, (value) async => value > 2);
  print(result); // 输出: 3
}
```

#### 22. detectLimit - 限制并发数执行函数列表，找到第一个满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  dynamic result = await detectLimit(functions, (value) async => value > 2, 2);
  print(result); // 输出: 3
}
```

#### 23. detectSeries - 串行执行函数列表，找到第一个满足条件的结果

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 1,
    () async => 2,
    () async => 3,
    () async => 4,
    () async => 5
  ];
  
  dynamic result = await detectSeries(functions, (value) async => value > 2);
  print(result); // 输出: 3
}
```

#### 24. parallel - 并行执行函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 'Task 1',
    () async => 'Task 2',
    () async => 'Task 3'
  ];
  
  List results = await parallel(functions);
  print(results); // 输出: [Task 1, Task 2, Task 3]
}
```

#### 25. series - 串行执行函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => 'Task 1',
    () async => 'Task 2',
    () async => 'Task 3'
  ];
  
  List results = await series(functions);
  print(results); // 输出: [Task 1, Task 2, Task 3]
}
```

#### 26. forEach - 并行遍历函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => print('Task 1'),
    () async => print('Task 2'),
    () async => print('Task 3')
  ];
  
  await forEach(functions);
  print('All tasks completed');
}
```

#### 27. forEachLimit - 限制并发数遍历函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => print('Task 1'),
    () async => print('Task 2'),
    () async => print('Task 3'),
    () async => print('Task 4'),
    () async => print('Task 5')
  ];
  
  await forEachLimit(functions, 2);
  print('All tasks completed');
}
```

#### 28. forEachSeries - 串行遍历函数列表

```dart
import 'package:curie/curie.dart';

void main() async {
  List<Function> functions = [
    () async => print('Task 1'),
    () async => print('Task 2'),
    () async => print('Task 3')
  ];
  
  await forEachSeries(functions);
  print('All tasks completed');
}
```

### 函数说明

#### 1. eachSeries

```dart
Future<List> eachSeries(List<Function> functions)
```

串行执行函数列表，返回所有函数的执行结果。

#### 2. eachLimit

```dart
Future<List> eachLimit(List<Function> functions, int limit,
    [void eachCallback(
        [int index,
        int running,
        int completeCount,
        bool done,
        List result])])
```

限制并发数执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `limit`：最大并发数
- `eachCallback`：可选，每个函数执行完成后的回调函数

#### 3. waterfall

```dart
Future<dynamic> waterfall(List<Function> functions)
```

瀑布流执行函数列表，将前一个函数的结果传递给下一个函数，返回最后一个函数的执行结果。

#### 4. some

```dart
Future<bool> some(List<Function> functions, [Function callback])
```

并行执行函数列表，只要有一个函数返回 true 就立即返回 true。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 5. someLimit

```dart
Future<bool> someLimit(List<Function> functions, int limit, [Function callback, bool immediateEnd = true])
```

限制并发数执行函数列表，只要有一个函数返回 true 就立即返回 true。

- `functions`：要执行的函数列表
- `limit`：最大并发数
- `callback`：可选，所有函数执行完成后的回调函数
- `immediateEnd`：可选，是否在找到第一个返回 true 的函数后立即结束，默认为 true

#### 6. someSeries

```dart
Future<bool> someSeries(List<Function> functions, [Function callback])
```

串行执行函数列表，只要有一个函数返回 true 就立即返回 true。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 7. every

```dart
Future<bool> every(List<Function> functions, [Function callback])
```

并行执行函数列表，所有函数都返回 true 才返回 true。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 8. everyLimit

```dart
Future<bool> everyLimit(List<Function> functions, int limit, [Function callback, bool immediateEnd = true])
```

限制并发数执行函数列表，所有函数都返回 true 才返回 true。

- `functions`：要执行的函数列表
- `limit`：最大并发数
- `callback`：可选，所有函数执行完成后的回调函数
- `immediateEnd`：可选，是否在找到第一个返回 false 的函数后立即结束，默认为 true

#### 9. everySeries

```dart
Future<bool> everySeries(List<Function> functions, [Function callback])
```

串行执行函数列表，所有函数都返回 true 才返回 true。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 10. times

```dart
Future<List> times(Function function, int times, [Function callback])
```

并行执行函数指定次数，返回所有执行结果。

- `function`：要执行的函数
- `times`：执行次数
- `callback`：可选，所有执行完成后的回调函数

#### 11. timesSeries

```dart
Future<List> timesSeries(Function function, int times, [Function callback])
```

串行执行函数指定次数，返回所有执行结果。

- `function`：要执行的函数
- `times`：执行次数
- `callback`：可选，所有执行完成后的回调函数

#### 12. timesLimit

```dart
Future<List> timesLimit(Function function, int times, int limit, [Function callback])
```

限制并发数执行函数指定次数，返回所有执行结果。

- `function`：要执行的函数
- `times`：执行次数
- `limit`：最大并发数
- `callback`：可选，所有执行完成后的回调函数

#### 13. retry

```dart
Future retry(Function function, int times, Function interval, [Function callback])
```

重试函数执行，直到成功或达到最大重试次数。

- `function`：要执行的函数
- `times`：最大重试次数
- `interval`：每次重试的间隔时间（毫秒）
- `callback`：可选，执行完成后的回调函数

#### 14. map

```dart
Future<List> map(List<Function> functions, [Function callback])
```

并行执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 15. mapLimit

```dart
Future<List> mapLimit(List<Function> functions, int limit, [Function callback])
```

限制并发数执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `limit`：最大并发数
- `callback`：可选，所有函数执行完成后的回调函数

#### 16. mapSeries

```dart
Future<List> mapSeries(List<Function> functions, [Function callback])
```

串行执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 17. filter

```dart
Future<List> filter(List<Function> functions, Function predicate, [Function callback])
```

并行执行函数列表，过滤出满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `callback`：可选，所有函数执行完成后的回调函数

#### 18. filterLimit

```dart
Future<List> filterLimit(List<Function> functions, Function predicate, int limit, [Function callback])
```

限制并发数执行函数列表，过滤出满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `limit`：最大并发数
- `callback`：可选，所有函数执行完成后的回调函数

#### 19. filterSeries

```dart
Future<List> filterSeries(List<Function> functions, Function predicate, [Function callback])
```

串行执行函数列表，过滤出满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `callback`：可选，所有函数执行完成后的回调函数

#### 20. reduce

```dart
Future<dynamic> reduce(List<Function> functions, Function reducer, [dynamic initialValue, Function callback])
```

将函数列表的结果累加到一个值。

- `functions`：要执行的函数列表
- `reducer`：累加函数，接收累积值和当前值，返回新的累积值
- `initialValue`：可选，初始累积值
- `callback`：可选，所有函数执行完成后的回调函数

#### 21. detect

```dart
Future<dynamic> detect(List<Function> functions, Function predicate, [Function callback])
```

并行执行函数列表，找到第一个满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `callback`：可选，执行完成后的回调函数

#### 22. detectLimit

```dart
Future<dynamic> detectLimit(List<Function> functions, Function predicate, int limit, [Function callback])
```

限制并发数执行函数列表，找到第一个满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `limit`：最大并发数
- `callback`：可选，执行完成后的回调函数

#### 23. detectSeries

```dart
Future<dynamic> detectSeries(List<Function> functions, Function predicate, [Function callback])
```

串行执行函数列表，找到第一个满足条件的结果。

- `functions`：要执行的函数列表
- `predicate`：判断函数，返回 true 表示满足条件
- `callback`：可选，执行完成后的回调函数

#### 24. parallel

```dart
Future<List> parallel(List<Function> functions, [Function callback])
```

并行执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 25. series

```dart
Future<List> series(List<Function> functions, [Function callback])
```

串行执行函数列表，返回所有函数的执行结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 26. forEach

```dart
Future<void> forEach(List<Function> functions, [Function callback])
```

并行遍历函数列表，不返回结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

#### 27. forEachLimit

```dart
Future<void> forEachLimit(List<Function> functions, int limit, [Function callback])
```

限制并发数遍历函数列表，不返回结果。

- `functions`：要执行的函数列表
- `limit`：最大并发数
- `callback`：可选，所有函数执行完成后的回调函数

#### 28. forEachSeries

```dart
Future<void> forEachSeries(List<Function> functions, [Function callback])
```

串行遍历函数列表，不返回结果。

- `functions`：要执行的函数列表
- `callback`：可选，所有函数执行完成后的回调函数

### 贡献

欢迎贡献代码！请按照以下步骤进行：

1. Fork 项目
2. 创建分支
3. 提交更改
4. 推送分支
5. 打开 Pull Request

### 许可证

MIT License

### 作者

Curie 由 Dart 开发者团队创建和维护。

---

**注意**：本库仍在持续开发中，如有任何问题或建议，请随时提出。