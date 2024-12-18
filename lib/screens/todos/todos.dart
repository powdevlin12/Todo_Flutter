import 'package:flutter/material.dart';
import 'package:learn_fluter/commons/widgets/search_common.dart';
import 'package:learn_fluter/models/todo_model.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];

  @override
  void initState() {
    super.initState();
    // _filteredTodos = _todos; // Ban đầu, danh sách lọc giống danh sách gốc
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _todos.add(Todo(
          id: DateTime.now().toString(),
          content: _controller.text,
          isDone: false,
        ));
      });
      _filteredTodos = _todos;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task Added: ${_controller.text}')),
      );
      _controller.clear();
      Navigator.pop(context);
    }
  }

  void _handleSearch(String value) {
    print("handle search$value");
    setState(() {
      if (value.isEmpty) {
        _filteredTodos = _todos;
      } else {
        _filteredTodos = _todos
            .where(
                (todo) => todo.content.toString().toLowerCase().contains(value))
            .toList();
      }
    });
  }

  void _handleDeleteItem(String contentSearch) {
    int indexInTodo = _todos.indexWhere((todo) =>
        todo.content.toString().toLowerCase().contains(contentSearch));
    setState(() {
      _todos.removeAt(indexInTodo);
      _filteredTodos = _todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 120 + MediaQuery.of(context).viewInsets.bottom,
                  // color: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                  alignment: Alignment.topLeft,
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter your task',
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
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.blueGrey.shade600,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Form
            SearchBarCommon(
              onSearch: _handleSearch,
            ),
            const SizedBox(height: 20),
            // Task List
            Expanded(
              child: _todos.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet. Add one!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTodos.length,
                      itemBuilder: (context, index) {
                        final todo = _filteredTodos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              todo.content,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: todo.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            leading: Checkbox(
                              shape: const CircleBorder(),
                              activeColor: Colors.blue,
                              value: todo.isDone,
                              onChanged: (value) {
                                setState(() {
                                  todo.isDone = value ?? false;
                                });
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _handleDeleteItem(todo.content);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
