import 'database.dart';

/// Classe pour gérer les opérations de base de données liées aux livres.
class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajoute un nouveau livre à la base de données.
  ///
  /// Retourne un `Future` contenant l'ID du livre nouvellement inséré.
  Future<int> ajouterLivre(String nomLivre, int idAuteur) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
    });
  }

  /// Récupère tous les livres de la base de données.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map représentant un livre.
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  /// Met à jour les informations d'un livre spécifique dans la base de données.
  ///
  /// Retourne un `Future` contenant le nombre de lignes affectées.
  Future<int> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur) async {
    final db = await _dbClient.database;
    return await db.update(
      'LIVRE',
      {'nomLivre': nomLivre, 'idAuteur': idAuteur},
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
  }

  /// Supprime un livre spécifique de la base de données.
  ///
  /// Retourne un `Future` contenant le nombre de lignes affectées.
  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  /// Récupère tous les livres écrits par un auteur spécifique.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map représentant un livre.
  Future<List<Map<String, dynamic>>> obtenirLivresParAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  /// Récupère tous les livres avec le nom de leur auteur.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map contenant les informations du livre et le nom de l'auteur.
  Future<List<Map<String, dynamic>>> obtenirTousLesLivresAvecNomAuteur() async {
    final db = await _dbClient.database;
    return await db.rawQuery('''
      SELECT LIVRE.*, AUTEUR.nomAuteur
      FROM LIVRE
      INNER JOIN AUTEUR ON LIVRE.idAuteur = AUTEUR.idAuteur
    ''');
  }
}
