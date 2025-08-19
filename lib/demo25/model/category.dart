class Category {
  final int? id;
  final String name;
  final String? createdAt;
  final int? createdUserId;

  Category({
    this.id,
    required this.name,
    this.createdAt,
    this.createdUserId,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdUserId': createdUserId
    };
  }
}