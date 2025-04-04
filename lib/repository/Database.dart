import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Client de base de données pour gérer la connexion à la base de données SQLite.
class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  static Database? _database;

  DatabaseClient._internal();

  /// Retourne l'instance unique de `DatabaseClient`.
  factory DatabaseClient() {
    return _instance;
  }

  /// Retourne une instance de la base de données. Initialise la base de données si elle n'existe pas.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données en ouvrant une connexion ou en créant une nouvelle si elle n'existe pas.
  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'bibliotheque.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Fonction appelée lors de la création de la base de données.
  ///
  /// Crée les tables AUTEUR et LIVRE avec leurs schémas respectifs.
  Future<void> _onCreate(Database db, int version) async {
    // Création de la table AUTEUR
    await db.execute('''
      CREATE TABLE AUTEUR (
        idAuteur INTEGER PRIMARY KEY AUTOINCREMENT,
        nomAuteur TEXT NOT NULL
      )
    ''');
    // Création de la table LIVRE
    await db.execute('''
      CREATE TABLE LIVRE (
        idLivre INTEGER PRIMARY KEY AUTOINCREMENT,
        nomLivre TEXT NOT NULL,
        idAuteur INTEGER,
        FOREIGN KEY (idAuteur) REFERENCES AUTEUR (idAuteur)
      )
    ''');
  }
}
