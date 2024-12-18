import 'package:flutter/material.dart';
import 'package:learn_fluter/screens/settings/setting.dart';
import 'package:learn_fluter/screens/todos/todos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomTab(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  // Biến để theo dõi chỉ số tab hiện tại
  int _currentIndex = 0;

  // Danh sách các màn hình
  final List<Widget> _screens = [
    const TodoApp(),
    const Screen2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Hiển thị màn hình tương ứng
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Tab đang được chọn
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật tab
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_sharp),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            label: 'State',
          ),
        ],
      ),
    );
  }
}
