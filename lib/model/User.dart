class User {
  final int? idUser;
  final String nomUser;
  final String prenomUser;
  final String loginUser;
  final String mdpUser;
  final String roleUser;

  User({
    this.idUser,
    required this.nomUser,
    required this.prenomUser,
    required this.loginUser,
    required this.mdpUser,
    required this.roleUser,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      idUser: map['idUser'] as int?,
      nomUser: map['nomUser'] as String,
      prenomUser: map['prenomUser'] as String,
      loginUser: map['loginUser'] as String,
      mdpUser: map['mdpUser'] as String,
      roleUser: map['roleUser'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': idUser,
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': mdpUser,
      'roleUser': roleUser,
    };
  }

  User copyWith({
    int? idUser,
    String? nomUser,
    String? prenomUser,
    String? loginUser,
    String? mdpUser,
    String? roleUser,
  }) {
    return User(
      idUser: idUser ?? this.idUser,
      nomUser: nomUser ?? this.nomUser,
      prenomUser: prenomUser ?? this.prenomUser,
      loginUser: loginUser ?? this.loginUser,
      mdpUser: mdpUser ?? this.mdpUser,
      roleUser: roleUser ?? this.roleUser,
    );
  }
}