import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: TodoApp());
  }
}
