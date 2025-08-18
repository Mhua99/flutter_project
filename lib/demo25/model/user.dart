class User {
  final int? id;
  final String username;
  final String password;
  final String? avatar;

  User({this.id, required this.username, required this.password, this.avatar});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      avatar: map['avatar'],
    );
  }
}
