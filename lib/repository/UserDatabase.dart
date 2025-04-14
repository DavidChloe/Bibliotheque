import 'package:bcrypt/bcrypt.dart';
import '../model/user.dart';
import 'database.dart';

class UserDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  Future<List<User>> obtenirTousLesUtilisateurs() async {
    final db = await _dbClient.database;
    final List<Map<String, dynamic>> result = await db.query('USERS');
    return result.map((userMap) => User.fromMap(userMap)).toList();
  }

  Future<int> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    final db = await _dbClient.database;
    final hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
    return await db.insert('USERS', {
      'nomUser': nomUser,
      'prenomUser': prenomUser,
      'loginUser': loginUser,
      'mdpUser': hashedPassword,
      'roleUser': roleUser,
    });
  }

  Future<int> mettreAJourUser({
    required int idUser,
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    final db = await _dbClient.database;
    final hashedPassword = BCrypt.hashpw(mdpUser, BCrypt.gensalt());
    return await db.update(
      'USERS',
      {
        'nomUser': nomUser,
        'prenomUser': prenomUser,
        'loginUser': loginUser,
        'mdpUser': hashedPassword,
        'roleUser': roleUser,
      },
      where: 'idUser = ?',
      whereArgs: [idUser],
    );
  }

  Future<int> supprimerUser(int idUser) async {
    final db = await _dbClient.database;
    return await db.delete('USERS', where: 'idUser = ?', whereArgs: [idUser]);
  }

  Future<User?> verifierLogin(String login, String password) async {
    final db = await _dbClient.database;
    final result = await db.query('USERS', where: 'loginUser = ?', whereArgs: [login]);

    print('Résultat brut BDD: $result');

    if (result.isNotEmpty) {
      final userMap = result.first;
      final hashed = userMap['mdpUser'];
      print('Mot de passe haché en BDD: $hashed');
      print('Mot de passe saisi: $password');

      if (hashed is String && BCrypt.checkpw(password, hashed)) {
        print('Mot de passe correct !');
        return User.fromMap(userMap);
      } else {
        print('Mot de passe incorrect');
      }
    } else {
      print('Aucun utilisateur trouvé avec ce login');
    }

    return null;
  }

  Future<Map<String, dynamic>?> obtenirUserParLogin(String loginUser) async {
    final db = await _dbClient.database;
    final result = await db.query('USERS', where: 'loginUser = ?', whereArgs: [loginUser]);
    return result.isNotEmpty ? result.first : null;
  }
}
