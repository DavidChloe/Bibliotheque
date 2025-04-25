import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../model/LivreGenre.dart';

class LivreGenreDatabase {
  static Database? _database;

  // Singleton pour éviter plusieurs instances de DB
  static Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'livre.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Assure-toi que ta table existe (optionnel ici)
        await db.execute('''
          CREATE TABLE IF NOT EXISTS LIVREGENRE (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            idLivre INTEGER NOT NULL,
            idGenre INTEGER NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  // Ajouter une association
  static Future<void> associerLivreGenre(int idLivre, int idGenre) async {
    final db = await database;
    await db.insert('LIVREGENRE', {
      'idLivre': idLivre,
      'idGenre': idGenre,
    });
  }

  // Récupérer l'idGenre à partir de l'idLivre
  static Future<int?> getGenreIdByLivre(int idLivre) async {
    final db = await database;
    final result = await db.query(
      'LIVREGENRE',
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
    if (result.isNotEmpty) {
      return result.first['idGenre'] as int?;
    }
    return null;
  }

  // Récupérer tous les LivreGenre
  static Future<List<LivreGenre>> getAllAssociations() async {
    final db = await database;
    final result = await db.query('LIVREGENRE');
    return result.map((map) => LivreGenre.fromMap(map)).toList();
  }

  // Supprimer une association
  Future<void> supprimerAssociationsPourLivre(int idLivre) async {
    final db = await database;
    await db.delete('LIVREGENRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  Future<void> ajouterAssociation(int idLivre, int idGenre) async {
    final db = await database;
    await db.insert('LIVREGENRE', {
      'idLivre': idLivre,
      'idGenre': idGenre,
    });
  }

}
