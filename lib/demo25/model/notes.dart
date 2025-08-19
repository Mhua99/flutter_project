class Note {
  final int? id;
  final int? createdUserId;
  final String title;
  final String content;
  final String color;
  final String dateTime;
  final String category;
  final String? createdAt;

  Note({
    this.id,
    this.createdUserId,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
    required this.category,
    this.createdAt
  });

  /// toMap() 方法
  /// 将 Note 对象转换为 Map<String, dynamic> 格式
  /// 用于将对象数据存储到数据库（如 SQLite）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'dateTime': dateTime,
      'category': category,
      'createdUserId': createdUserId,
    };
  }

  /// fromMap() 工厂构造函数：
  /// 从 Map<String, dynamic> 数据创建 Note 对象
  /// 用于从数据库读取数据并还原为对象
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      dateTime: map['dateTime'],
      category: map['category'],
      createdUserId: map['createdUserId'],
      createdAt: map['createdAt'],
    );
  }
}
