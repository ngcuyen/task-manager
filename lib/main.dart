import 'package:flutter/material.dart';
import 'package:task_manager/screens/dashboard.dart';
import 'package:task_manager/screens/task_detail.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TaskDetailScreen());
  }
}
