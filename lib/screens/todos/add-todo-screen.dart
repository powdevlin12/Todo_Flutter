// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:learn_fluter/models/todo_model.dart';
import 'package:learn_fluter/screens/todos/todos_storage.dart';
import 'package:learn_fluter/services/local_notification.dart';
import 'package:learn_fluter/utils/snackbarCustom.dart';

class AddTodoScreen extends StatefulWidget {
  final String type;
  Todo? todo;

  AddTodoScreen({
    super.key,
    required this.type,
    this.todo,
  });

  @override
  createState() => AddTodoScreenState(type: type, todo: todo);
}

class AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<Todo> _todos = [];

  // edit or add
  final String type;
  Todo? todo;
// Constructor để nhận dữ liệu
  AddTodoScreenState({required this.type, this.todo});

  @override
  void initState() {
    _loadTodos();
    super.initState();
    _controller.value = type == "add"
        ? const TextEditingValue(text: "")
        : TextEditingValue(text: todo?.content ?? "");
    _descriptionController.value = type == "add"
        ? const TextEditingValue(text: "")
        : TextEditingValue(text: todo?.description ?? "");
    _dateController.value = type == "add"
        ? const TextEditingValue(text: "")
        : TextEditingValue(text: todo?.date ?? "");
  }

  Future<void> _loadTodos() async {
    final List<Todo> loadedTodos = await TodoStorage.loadTodos();
    setState(() {
      _todos = loadedTodos;
    });
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate:
            type == "add" ? DateTime.now() : DateTime.parse(todo?.date ?? ""));
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Todo todo = Todo(
          id: DateTime.now().toString(),
          content: _controller.text,
          isDone: false,
          description: _descriptionController.text,
          date: _dateController.text);
      setState(() {
        _todos.add(todo);
        _dateController.text = "";
      });
      TodoStorage.saveTodos(_todos);
      openSnackbar(context, 'Task Added: ${_controller.text}');
      LocalNotification.displayNotification(
          title: "Todo App Thông báo",
          content: "Đã thêm công việc ${_controller.text}");
      _controller.clear();
      Navigator.pop(context);
    }
  }

  void _handleUpdateTodo() {
    if (_formKey.currentState!.validate()) {
      Todo todoEdit = Todo(
          id: todo?.id ?? "",
          content: _controller.text,
          isDone: todo?.isDone ?? false,
          description: _descriptionController.text ?? "",
          date: _dateController.text);
      setState(() {
        _dateController.text = "";
      });

      int indexTodo = _todos.indexWhere((i) => i.id == todoEdit.id);
      _todos[indexTodo] = todoEdit;
      TodoStorage.saveTodos(_todos);
      openSnackbar(context, 'Update success : ${_controller.text}');
      _controller.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == "add" ? 'Add Todo' : 'Edit todo',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your task',
                  labelText: 'Todo name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    labelText: 'Date',
                    filled: true,
                    prefixIcon: const Icon(Icons.calendar_today),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(10, 12))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade700))),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: type == 'add' ? _submitForm : _handleUpdateTodo,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.grey.shade700),
                  child: Text(
                    type == "add" ? 'Add' : 'Update',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
