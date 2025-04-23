import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';

class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Database? _database;

  factory DatabaseClient() => _instance;
  DatabaseClient._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bibliotheque.db');

    return await openDatabase(
      path,
      version: 2, // number of migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE AUTEUR (
        idAuteur INTEGER PRIMARY KEY AUTOINCREMENT,
        nomAuteur TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE LIVRE (
        idLivre INTEGER PRIMARY KEY AUTOINCREMENT,
        nomLivre TEXT NOT NULL,
        idAuteur INTEGER,
        jacket TEXT, -- ✅ directement présente si DB neuve
        FOREIGN KEY (idAuteur) REFERENCES AUTEUR (idAuteur)
      )
    ''');

    await db.execute('''
      CREATE TABLE USERS (
        idUser INTEGER PRIMARY KEY AUTOINCREMENT,
        nomUser TEXT NOT NULL,
        prenomUser TEXT NOT NULL,
        loginUser TEXT NOT NULL UNIQUE,
        mdpUser TEXT NOT NULL,
        roleUser TEXT NOT NULL
      )
    ''');

    // 🔐 Comptes par défaut avec mot de passe hashé
    await db.insert('USERS', {
      'nomUser': 'Admin',
      'prenomUser': 'Administrateur',
      'loginUser': 'admin',
      'mdpUser': BCrypt.hashpw('admin123', BCrypt.gensalt()),
      'roleUser': 'admin',
    });

    await db.insert('USERS', {
      'nomUser': 'User',
      'prenomUser': 'utilisateur',
      'loginUser': 'user',
      'mdpUser': BCrypt.hashpw('user123', BCrypt.gensalt()),
      'roleUser': 'user',
    });
  }

  // Pour gérer les mises à jour de structure de la base
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 🆕 Ajout de la colonne jacket si elle n'existe pas
      await db.execute('ALTER TABLE LIVRE ADD COLUMN jacket TEXT');
    }
  }
}
