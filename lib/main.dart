import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:learn_fluter/screens/packages/packages_screen.dart';
import 'package:learn_fluter/screens/todos/todos.dart';
import 'package:learn_fluter/services/local_notification.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotification.init();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoApp(),
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
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TodoApp(),
    PackagesScreen(),
    Text('Page 3'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
        items: [
          BottomNavyBarItem(
            icon: const Center(
              child: Icon(Icons.home),
            ),
            title: const Text(
              'Todo',
            ),
            textAlign: TextAlign.center,
            inactiveColor: Colors.grey,
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.playlist_add_check_circle),
            title: const Text('Package'),
            textAlign: TextAlign.center,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Profile'),
            textAlign: TextAlign.center,
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
