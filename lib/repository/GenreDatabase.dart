import 'Database.dart';

/// Classe pour gérer les opérations de base de données liées aux genres.
class GenreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajoute un genre dans la table GENRE
  Future<int> ajouterGenre(String nomGenre) async {
    final db = await _dbClient.database;
    return await db.insert('GENRE', {
      'nomGenre': nomGenre,
    });
  }

  /// Récupère tous les genres de la base
  Future<List<Map<String, dynamic>>> obtenirTousLesGenres() async {
    final db = await _dbClient.database;
    return await db.query('GENRE');
  }

  /// Met à jour un genre existant
  Future<int> mettreAJourGenre(int idGenre, String nomGenre) async {
    final db = await _dbClient.database;
    return await db.update(
      'GENRE',
      {'nomGenre': nomGenre},
      where: 'idGenre = ?',
      whereArgs: [idGenre],
    );
  }

  /// Supprime un genre par son ID
  Future<int> supprimerGenre(int idGenre) async {
    final db = await _dbClient.database;
    return await db.delete('GENRE', where: 'idGenre = ?', whereArgs: [idGenre]);
  }

  /// Récupère les genres triés par nom
  Future<List<Map<String, dynamic>>> obtenirGenresTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query(
      'GENRE',
      orderBy: "nomGenre ASC",
    );
  }

  /// Retourne tous les livres liés à un genre (si tu ajoutes une liaison)
  Future<List<Map<String, dynamic>>> obtenirLivresParGenre(int idGenre) async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      where: 'idGenre = ?',
      whereArgs: [idGenre],
    );
  }
}
