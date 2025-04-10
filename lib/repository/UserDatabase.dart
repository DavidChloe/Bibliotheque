import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../model/user.dart';

class UserDatabase {
  static const String tableName = 'users';
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'user_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT UNIQUE,
        passwordHash TEXT,
        role TEXT
      )
    ''');
  }

  Future<int> addUser(User user) async {
    final db = await database;
    return db.insert(tableName, user.toMap());
  }

  Future<User?> getUserByUsername(String userName) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      tableName,
      where: 'userName = ?',
      whereArgs: [userName],
    );
    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return db.update(
      tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
