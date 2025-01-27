import 'package:flutter/material.dart';
import 'package:learn_fluter/commons/widgets/search_common.dart';
import 'package:learn_fluter/models/todo_model.dart';
import 'package:learn_fluter/screens/todos/todos_storage.dart';
import 'package:learn_fluter/services/local_notification.dart';
import 'package:learn_fluter/utils/SnackbarCustom.dart';
import 'package:learn_fluter/screens/todos/add-todo-screen.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  createState() => _TodoAppState();
}

enum SingingCharacter { all, done, notDone }

class _TodoAppState extends State<TodoApp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];
  List<Todo> _filteredTodos = [];
  final TextEditingController _dateController = TextEditingController();
  SingingCharacter? _character = SingingCharacter.all;

  @override
  void initState() {
    super.initState();
    _loadTodos().then((value) {
      LocalNotification.askPermissionNotification();
    });
    // _filteredTodos = _todos; // Ban đầu, danh sách lọc giống danh sách gốc
  }

  Future<void> _loadTodos() async {
    final List<Todo> loadedTodos = await TodoStorage.loadTodos();
    setState(() {
      _todos = loadedTodos;
      _filteredTodos = _todos;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Todo todo = Todo(
          id: DateTime.now().toString(),
          content: _controller.text,
          isDone: false,
          date: _dateController.text);
      setState(() {
        _todos.add(todo);
        _dateController.text = "";
      });
      _filteredTodos = _todos;
      TodoStorage.saveTodos(_todos);
      openSnackbar(context, 'Task Added: ${_controller.text}');
      _controller.clear();
      Navigator.pop(context);
    }
  }

  void _handleSearch(String value) {
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

  void _handleDeleteItem(String id) {
    final todoToDelete = _todos.firstWhere((todo) => todo.id == id);
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
      _filteredTodos = _todos;
    });

    TodoStorage.saveTodos(_todos);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Todo deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _todos.add(todoToDelete);
            });
            TodoStorage.saveTodos(_todos);
          },
        ),
      ),
    );
  }

  void _handlePlusPoint(String id) {
    int todoIndex = _todos.lastIndexWhere((todo) => todo.id == id);

    final todoProcessing = _todos[todoIndex];
    todoProcessing.point = (todoProcessing.point!) + 1;

    setState(() {
      _todos[todoIndex] = todoProcessing;
      _filteredTodos = _todos;
    });

    TodoStorage.saveTodos(_todos);
  }

  void _handleSubPoint(String id) {
    int todoIndex = _todos.lastIndexWhere((todo) => todo.id == id);

    final todoProcessing = _todos[todoIndex];
    todoProcessing.point = (todoProcessing.point!) - 1;

    setState(() {
      _todos[todoIndex] = todoProcessing;
      _filteredTodos = _todos;
    });

    TodoStorage.saveTodos(_todos);
  }

  Future<void> toggleDoneTodo(String id, bool? isDone) async {
    int todoIndex = _todos.lastIndexWhere((todo) => todo.id == id);
    Todo todoProcess = _todos[todoIndex];
    todoProcess.isDone = isDone ?? false;

    setState(() {
      _todos[todoIndex] = todoProcess;
    });

    TodoStorage.saveTodos(_todos);
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

  void handleFilter() {
    List<Todo> tempList = [..._todos];

    if (_character == SingingCharacter.all) {
      tempList = _todos;
    } else if (_character == SingingCharacter.done) {
      tempList = tempList.where((todo) => todo.isDone).toList();
    } else {
      tempList = tempList.where((todo) => !todo.isDone).toList();
    }
    setState(() {
      _filteredTodos = tempList;
    });
    Navigator.pop(context);
  }

  void _navigationAddTodoPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddTodoScreen(
          type: "add",
          todo: null,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Bắt đầu từ bên phải
          const end = Offset.zero; // Kết thúc tại vị trí ban đầu
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ).then((result) {
      _loadTodos();
    });
  }

  void _navigationEditTodoPage(Todo todo) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddTodoScreen(type: "edit", todo: todo),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Bắt đầu từ bên phải
          const end = Offset.zero; // Kết thúc tại vị trí ban đầu
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ).then((result) {
      _loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BaiBac',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigationAddTodoPage();
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
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_list_sharp,
                    size: 32,
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              height: 300 +
                                  MediaQuery.of(context).viewInsets.bottom,
                              // color: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text(
                                    'Type todo',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      RadioListTile<SingingCharacter>(
                                        title: const Text('All'),
                                        value: SingingCharacter.all,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                      RadioListTile<SingingCharacter>(
                                        title: const Text('Done'),
                                        value: SingingCharacter.done,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                      RadioListTile<SingingCharacter>(
                                        title: const Text('Not Done'),
                                        value: SingingCharacter.notDone,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: handleFilter,
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 24,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          backgroundColor:
                                              Colors.grey.shade700),
                                      child: const Text(
                                        'Filter',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 4),
            // Task List
            Expanded(
              child: _todos.isEmpty
                  ? const Center(
                      child: Text(
                        'No Data!',
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
                                // Text(
                                //   todo.date,
                                //   style: const TextStyle(
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w600,
                                //       color: Colors.grey),
                                // ),
                                Text(
                                  todo.content,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                if (todo.point != null)
                                  Text(
                                    todo.point.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: todo.point! >= 0
                                            ? Colors.blueAccent
                                            : Colors.red),
                                  )
                              ],
                            ),
                            leading: Checkbox(
                              shape: const CircleBorder(),
                              activeColor: Colors.blue,
                              value: todo.isDone,
                              onChanged: (value) {
                                toggleDoneTodo(todo.id, value);
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
                                    : Row(
                                        children: [
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                                icon: const Icon(Icons.add,
                                                    color: Colors.blue),
                                                onPressed: () =>
                                                    _handlePlusPoint(todo.id)),
                                          ),
                                          SizedBox(
                                            width: 40,
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.exposure_minus_1_sharp,
                                                  color: Colors.brown),
                                              onPressed: () =>
                                                  _handleSubPoint(todo.id),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 36,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () =>
                                                  _handleDeleteItem(todo.id),
                                            ),
                                          ),
                                        ],
                                      )
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
