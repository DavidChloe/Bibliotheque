import 'database.dart';

/// Classe pour gérer les opérations de base de données liées aux livres.
class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajoute un nouveau livre à la base de données avec éventuellement une jaquette.
  Future<int> ajouterLivre(String nomLivre, int idAuteur, {String? jacketPath}) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
      'jacket': jacketPath, // ✅ colonne jacket ajoutée
    });
  }

  /// Récupère tous les livres de la base de données.
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  /// Met à jour les informations d'un livre spécifique (avec jacket).
  Future<int> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur, {String? jacketPath}) async {
    final db = await _dbClient.database;
    return await db.update(
      'LIVRE',
      {
        'nomLivre': nomLivre,
        'idAuteur': idAuteur,
        'jacket': jacketPath, // ✅ mise à jour du champ jacket
      },
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
  }

  /// Supprime un livre spécifique.
  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  /// Récupère tous les livres d’un auteur.
  Future<List<Map<String, dynamic>>> obtenirLivresParAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  /// Récupère tous les livres avec nom d’auteur (jointure).
  Future<List<Map<String, dynamic>>> obtenirTousLesLivresAvecNomAuteur() async {
    final db = await _dbClient.database;
    return await db.rawQuery('''
    SELECT LIVRE.*, AUTEUR.idAuteur AS auteurId, AUTEUR.nomAuteur
    FROM LIVRE
    INNER JOIN AUTEUR ON LIVRE.idAuteur = AUTEUR.idAuteur
  ''');
  }

  /// Récupère tous les livres avec nom d’auteur (jointure).
  Future<List<Map<String, dynamic>>> obtenirTousLesLivresAvecGenre() async {
    final db = await _dbClient.database;
    return await db.rawQuery('''
    SELECT LIVRE.*, GENRE.idGenre AS genreId, GENRE.nomGenre
    FROM LIVRE
    INNER JOIN GENRE ON LIVRE.idLivre = Genre.idLivre
  ''');
  }
}
