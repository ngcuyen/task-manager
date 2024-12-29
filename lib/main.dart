import 'package:flutter/material.dart';
import 'package:task_manager/screens/dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DashboardScreen());
  }
}
