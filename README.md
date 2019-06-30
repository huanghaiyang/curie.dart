## Dart异步函数库

keep on developing

函数优先

### supports

+ eachSeries
```dart
Future<List> eachSeries(List<Function> functions) async
```
+ eachLimit
```dart
Future<List> eachLimit(List<Function> functions, int limit,
    [void eachCallback(
        [int index,
        int running,
        int completeCount,
        bool done,
        List result])])
```
+ waterfall
```dart
Future<dynamic> waterfall(List<Function> functions)
```
+ some
```dart
Future<bool> some(List<Function> functions, [Function callback])
```
+ someLimit
```dart
Future<bool> someLimit(List<Function> functions, int limit, [Function callback, bool immediateEnd = true])
```
+ someSeries
```dart
Future<bool> someSeries(List<Function> functions, [Function callback])
```
+ every
```dart
Future<bool> every(List<Function> functions, [Function callback])
```
+ everyLimit
```dart
Future<bool> everyLimit(List<Function> functions, int limit, [Function callback, bool immediateEnd = true])
```
+ everySeries
```dart
Future<bool> everySeries(List<Function> functions, [Function callback])
```
+ times
```dart
Future<List> times(Function function, int times, [Function callback])
```
+ timesSeries
```dart
Future<List> timesSeries(Function function, int times, [Function callback])
```
+ timesLimit
```dart

Future<List> timesLimit(Function function, int times, int limit, [Function callback]) 
```
