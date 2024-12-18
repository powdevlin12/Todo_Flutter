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
  final TextEditingController _dateController = TextEditingController();

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
            date: _dateController.text));
        _dateController.text = "";
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
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
                  height: 300 + MediaQuery.of(context).viewInsets.bottom,
                  // color: Colors.amber,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                  alignment: Alignment.topLeft,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        const SizedBox(width: 12),
                        TextField(
                          controller: _dateController,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: 'Date',
                              filled: true,
                              prefixIcon: const Icon(Icons.calendar_today),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade700))),
                          readOnly: true,
                          onTap: () {
                            _selectDate();
                          },
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.grey.shade700),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.date,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                                Text(
                                  todo.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                )
                              ],
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                todo.isDone
                                    ? IconButton(
                                        icon: const Icon(Icons.check,
                                            color: Colors.blueAccent),
                                        onPressed: () => {},
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _handleDeleteItem(todo.id),
                                      ),
                              ],
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
