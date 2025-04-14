import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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

    //await deleteDatabase(path);   // !!! Supprimer l'ancienne base locale (à faire UNE FOIS pour réinitialiser)

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

    // Création de la table USERS (cohérence des noms de colonnes)
    await db.execute('''
    CREATE TABLE IF NOT EXISTS USERS (
      idUser INTEGER PRIMARY KEY AUTOINCREMENT,
      nomUser TEXT NOT NULL,
      prenomUser TEXT NOT NULL,
      loginUser TEXT NOT NULL UNIQUE,
      mdpUser TEXT NOT NULL,
      roleUser TEXT NOT NULL
    )
  ''');

    // Hachage des mots de passe
    String hashedAdminPassword = BCrypt.hashpw('admin123', BCrypt.gensalt());
    String hashedUserPassword = BCrypt.hashpw('user123', BCrypt.gensalt());

    // Insertion des utilisateurs par défaut
    await db.insert('USERS', {
      'nomUser': 'Admin',
      'prenomUser': 'Administrateur',
      'loginUser': 'admin', // ✅ correspond à la colonne loginUser
      'mdpUser': hashedAdminPassword,
      'roleUser': 'admin',
    });

    await db.insert('USERS', {
      'nomUser': 'User',
      'prenomUser': 'utilisateur',
      'loginUser': 'user',
      'mdpUser': hashedUserPassword,
      'roleUser': 'user',
    });
  }
}