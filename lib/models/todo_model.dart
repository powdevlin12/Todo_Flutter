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
}
