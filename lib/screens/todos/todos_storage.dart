import 'dart:convert';
import 'package:learn_fluter/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoStorage {
  static const String _keyTodos = "todos";

  // Save todos to SharedPreferences
  static Future<void> saveTodos(List<Todo> todos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> todosJson =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(_keyTodos, todosJson);
  }

  // Load todos from SharedPreferences
  static Future<List<Todo>> loadTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? todosJson = prefs.getStringList(_keyTodos);

    if (todosJson == null) return [];

    return todosJson.map((todoString) {
      final Map<String, dynamic> todoMap = jsonDecode(todoString);
      return Todo.fromJson(todoMap);
    }).toList();
  }
}
