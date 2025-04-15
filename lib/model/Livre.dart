import 'Auteur.dart';

class Livre {
  // Attributs
  int? _idLivre;
  late String _nomLivre;
  late int _idAuteur;         // <- idAuteur directement stocké
  late Auteur _auteur;
  String? _jacketPath;

  // Constructeur
  Livre({
    int? idLivre,
    required String nomLivre,
    required int idAuteur,
    required Auteur auteur,
    String? jacketPath,
  })  : _idLivre = idLivre,
        _nomLivre = nomLivre,
        _idAuteur = idAuteur,
        _auteur = auteur,
        _jacketPath = jacketPath;

  // Getters
  int? get idLivre => _idLivre;
  String get nomLivre => _nomLivre;
  int get idAuteur => _idAuteur;
  Auteur get auteur => _auteur;
  String get nomAuteur => _auteur.nomAuteur;
  String? get jacketPath => _jacketPath;

  // Setters
  set nomLivre(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Le nom du livre ne peut pas être vide.');
    }
    _nomLivre = value;
  }

  set jacketPath(String? value) {
    _jacketPath = value;
  }

  set idAuteur(int value) {
    _idAuteur = value;
  }

  // Convertir un Livre en Map (pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'idLivre': _idLivre,
      'nomLivre': _nomLivre,
      'idAuteur': _idAuteur,
      'jacket': _jacketPath,
    };
  }

  // Créer un Livre à partir d'une Map (depuis la base de données)
  factory Livre.fromMap(Map<String, dynamic> map, Auteur auteur) {
    return Livre(
      idLivre: map['idLivre'],
      nomLivre: map['nomLivre'],
      idAuteur: map['idAuteur'], // <- important ici aussi
      auteur: auteur,
      jacketPath: map['jacket'],
    );
  }
}
