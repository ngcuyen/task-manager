import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screens/dashboard.dart';
import 'package:task_manager/screens/new_task.dart';
import 'package:task_manager/screens/task_detail.dart';
import 'package:task_manager/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Khởi tạo NotificationService
  // final notificationService = NotificationService();
  // await notificationService.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _pages = [
    TaskDetailScreen(), // Màn hình Task Detail
    DashboardScreen(), // Màn hình Dashboard
    NewTaskScreen(), // Màn hình New Task
  ];

  // Cập nhật chỉ số khi người dùng nhấn vào item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _pages[_selectedIndex], // Hiển thị màn hình tương ứng
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.yellow[50],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.task),
              label: 'Task Detail',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'New Task',
            ),
          ],
        ),
      ),
    );
  }
}
