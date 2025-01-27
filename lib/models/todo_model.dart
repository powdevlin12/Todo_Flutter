class Todo {
  String id;
  String content;
  bool isDone;
  String date;
  String? description;
  int? point;
  Todo(
      {required this.id,
      required this.content,
      required this.date,
      this.description = '',
      this.isDone = false,
      this.point = 0});

  // Convert Todo to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isDone': isDone,
      'date': date,
      'description': description,
      'point': point
    };
  }

  // Convert JSON to Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        id: json['id'],
        content: json['content'],
        isDone: json['isDone'],
        date: json['date'],
        description: json['description'],
        point: json['point']);
  }
}
