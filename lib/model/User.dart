class User {
  int? id;
  String userName;
  String passwordHash;
  String role;

  User({this.id, required this.userName, required this.passwordHash, required this.role});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'passwordHash': passwordHash,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      userName: map['userName'],
      passwordHash: map['passwordHash'],
      role: map['role'],
    );
  }
}
