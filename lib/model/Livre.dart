import 'Auteur.dart';

class Livre {
  //Attributs privés
  int? _idLivre;
  String _nomLivre;
  Auteur _auteur;

  // Constructeur
  Livre({int? idLivre, required String nomLivre, required Auteur auteur})
      : _idLivre = idLivre,
        _nomLivre = nomLivre,
        _auteur = auteur;

  // Getters
  int? get idLivre => _idLivre;
  String get nomLivre => _nomLivre;
  Auteur get auteur => _auteur; // Retourne L'obtet Auteur complet

  // Setters
  set nomLivre(String value) {
    _nomLivre = value;
  }



  // Méthode pour convertir un Livre en Map (pour la base de données)
 /* Map<String, dynamic> toMap() {
    return {
      'idLivre': _idLivre,
      'nomLivre': _nomLivre,
      'idAuteur': _auteur.idAuteur
    };
  }*/

  // Méthode pour créer un Livre à partir d'un Map (depuis la base de données)
  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      idLivre: map['idLivre'],
      nomLivre: map['nomLivre'],
      auteur: Auteur.fromMap(map),
    );
  }
}