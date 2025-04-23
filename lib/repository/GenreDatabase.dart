import 'Database.dart';

/// Classe pour gérer les opérations de base de données liées aux genres.
class GenreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Retourne un `Future` contenant l'ID de l'genre nouvellement inséré.
  Future<int> ajouterGenre(String nomGenre) async {
    final db = await _dbClient.database;
    return await db.insert('AUTEUR', {
      'nomGenre': nomGenre,
    });
  }

  /// Récupère tous les genres de la base de données.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map représentant un genre.
  Future<List<Map<String, dynamic>>> obtenirTousLesGenres() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR');
  }

  /// Met à jour le nom d'un genre spécifique dans la base de données.
  ///
  /// Retourne un `Future` contenant le nombre de lignes affectées.
  Future<int> mettreAJourGenre(int idGenre, String nomGenre) async {
    final db = await _dbClient.database;
    return await db.update(
      'AUTEUR',
      {'nomGenre': nomGenre},
      where: 'idGenre = ?',
      whereArgs: [idGenre],
    );
  }

  // Supprime un genre spécifique de la base de données.
  Future<int> supprimerGenre(int idGenre) async {
    final db = await _dbClient.database;
    return await db.delete('AUTEUR', where: 'idGenre = ?', whereArgs: [idGenre]);
  }

  // Récupère tous les genres de la base de données, triés par ordre alphabétique de leur nom.
  Future<List<Map<String, dynamic>>> obtenirGenresTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query(
      'AUTEUR',
      orderBy: "nomGenre ASC",
    );
  }

  // Récupère tous les livres écrits par un genre spécifique.
  Future<List<Map<String, dynamic>>> obtenirLivresParGenre(int idGenre) async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      where: 'idGenre = ?',
      whereArgs: [idGenre],
    );
  }
}