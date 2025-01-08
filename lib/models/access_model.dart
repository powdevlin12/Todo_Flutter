class Access {
  final int id;
  final int collectionId;
  final String name;
  final bool isChecked;

  Access({
    required this.id,
    required this.collectionId,
    required this.name,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'collectionId': collectionId,
      'name': name,
      'isChecked': isChecked ? 1 : 0,
    };
  }

  factory Access.fromMap(Map<String, dynamic> map) {
    return Access(
      id: map['id'],
      collectionId: map['collectionId'],
      name: map['name'],
      isChecked: map['isChecked'] == 1,
    );
  }
}
