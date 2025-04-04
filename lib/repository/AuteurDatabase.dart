import 'Database.dart';

class AuteurDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  // Ajouter un auteur
  Future<int> ajouterAuteur(String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.insert('AUTEUR', {
      'nomAuteur': nomAuteur,
    });
  }

  // Récupérer tous les auteurs
  Future<List<Map<String, dynamic>>> obtenirTousLesAuteurs() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR');
  }

  // Mettre à jour un auteur
  Future<int> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.update(
      'AUTEUR',
      {'nomAuteur': nomAuteur},
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  // Supprimer un auteur
  Future<int> supprimerAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.delete('AUTEUR', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  // Liste auteurs par ordre alphabétique
  Future<List<Map<String, dynamic>>> obtenirAuteursTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query(
        'AUTEUR',
        orderBy: "nomAuteur ASC"
    );
  }

  //Récupérer les lives d'un auteur
  Future<List<Map<String, dynamic>>> obtenirLivresParAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.query(
        'LIVRE', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

}