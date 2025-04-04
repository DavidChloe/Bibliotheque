import 'Database.dart';

/// Classe pour gérer les opérations de base de données liées aux auteurs.
class AuteurDatabase {
  final DatabaseClient _dbClient = DatabaseClient();

  /// Ajoute un nouvel auteur à la base de données.
  ///
  /// Retourne un `Future` contenant l'ID de l'auteur nouvellement inséré.
  Future<int> ajouterAuteur(String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.insert('AUTEUR', {
      'nomAuteur': nomAuteur,
    });
  }

  /// Récupère tous les auteurs de la base de données.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map représentant un auteur.
  Future<List<Map<String, dynamic>>> obtenirTousLesAuteurs() async {
    final db = await _dbClient.database;
    return await db.query('AUTEUR');
  }

  /// Met à jour le nom d'un auteur spécifique dans la base de données.
  ///
  /// Retourne un `Future` contenant le nombre de lignes affectées.
  Future<int> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    final db = await _dbClient.database;
    return await db.update(
      'AUTEUR',
      {'nomAuteur': nomAuteur},
      where: 'idAuteur = ?',
      whereArgs: [idAuteur],
    );
  }

  /// Supprime un auteur spécifique de la base de données.
  ///
  /// Retourne un `Future` contenant le nombre de lignes affectées.
  Future<int> supprimerAuteur(int idAuteur) async {
    final db = await _dbClient.database;
    return await db.delete('AUTEUR', where: 'idAuteur = ?', whereArgs: [idAuteur]);
  }

  /// Récupère tous les auteurs de la base de données, triés par ordre alphabétique de leur nom.
  ///
  /// Retourne un `Future` contenant une liste de maps, chaque map représentant un auteur.
  Future<List<Map<String, dynamic>>> obtenirAuteursTriesAlphabetiquement() async {
    final db = await _dbClient.database;
    return await db.query(
      'AUTEUR',
      orderBy: "nomAuteur ASC",
    );
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
}
