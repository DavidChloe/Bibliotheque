import 'database.dart';

class LivreDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  // Ajouter un livre
  Future<int> ajouterLivre(String nomLivre, int idAuteur) async {
    final db = await _dbClient.database;
    return await db.insert('LIVRE', {
      'nomLivre': nomLivre,
      'idAuteur': idAuteur,
    });
  }

  // Récupérer tous les livres
  Future<List<Map<String, dynamic>>> obtenirTousLesLivres() async {
    final db = await _dbClient.database;
    return await db.query('LIVRE');
  }

  // Mettre à jour un livre
  Future<int> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur) async {
    final db = await _dbClient.database;
    return await db.update(
      'LIVRE',
      {'nomLivre': nomLivre, 'idAuteur': idAuteur},
      where: 'idLivre = ?',
      whereArgs: [idLivre],
    );
  }

  // Supprimer un livre
  Future<int> supprimerLivre(int idLivre) async {
    final db = await _dbClient.database;
    return await db.delete('LIVRE', where: 'idLivre = ?', whereArgs: [idLivre]);
  }

  // Récupérer les livres d'un auteur spécifique
  Future<List<Map<String, dynamic>>> obtenirLivresParAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.query(
      'LIVRE',
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  // Récupérer tous les livres avec le nom de l'auteur
  Future<List<Map<String, dynamic>>> obtenirTousLesLivresAvecNomAuteur() async {
    final db = await _dbClient.database;
    return await db.rawQuery('''
      SELECT LIVRE.*, AUTEUR.nomAuteur 
      FROM LIVRE 
      INNER JOIN AUTEUR ON LIVRE.idAuteur = AUTEUR.idAuteur
    ''');
  }

}