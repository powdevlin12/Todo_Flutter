class CollectionModel {
  final int? id;
  final String name;

  CollectionModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(id: map['id'], name: map['name']);
  }
}
