class Todo {
  String id;
  String content;
  bool isDone;
  String date;

  Todo(
      {required this.id,
      required this.content,
      required this.date,
      this.isDone = false});

  // Convert Todo to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'content': content, 'isDone': isDone, 'date': date};
  }

  // Convert JSON to Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        content: json['content'],
        isDone: json['isDone'],
        date: json['date']);
  }
}
