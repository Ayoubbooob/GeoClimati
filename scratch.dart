void main() {
  performTasks();
}

void performTasks() async {
  task1();
  String taskData = await task2();
  task3(taskData);
}

void task1() {
  // ignore: avoid_print
  print('Task 1 complete');
}

Future<String> task2() async {
  String result = "";
  await Future.delayed(const Duration(seconds: 3), () async {
    // ignore: avoid_print
    print('Task 2 complete');
    result = 'task 2 data';
  });
  return result;
}

void task3(String taskData) {
  // ignore: avoid_print
  print('Task 3 completed with Data : $taskData');
}
