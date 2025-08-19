class User {
  final int? id;
  final String username;
  final String password;
  final String? avatar;
  final String? email;
  final String? createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    this.avatar,
    this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'avatar': avatar,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      avatar: map['avatar'],
      email: map['email'],
      createdAt: map['createdAt'],
    );
  }
}
