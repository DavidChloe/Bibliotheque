/// @file Livre.dart
/// @brief Modèle de données représentant un livre.

import 'Auteur.dart';

/// @class Livre
/// @brief Classe représentant un livre.
/// 
/// Cette classe contient les informations sur un livre ainsi que son auteur.
class Livre {
  int? _idLivre;
  String _nomLivre;
  Auteur _auteur;

  /// Constructeur de la classe Livre.
  /// 
  /// @param idLivre Identifiant unique du livre.
  /// @param nomLivre Nom du livre.
  /// @param auteur Objet Auteur associé au livre.
  Livre({int? idLivre, required String nomLivre, required Auteur auteur})
      : _idLivre = idLivre,
        _nomLivre = nomLivre,
        _auteur = auteur;

  /// Retourne l'identifiant du livre.
  int? get idLivre => _idLivre;

  /// Retourne le nom du livre.
  String get nomLivre => _nomLivre;

  /// Retourne l'objet Auteur associé au livre.
  Auteur get auteur => _auteur;

  /// Modifie le nom du livre.
  set nomLivre(String value) {
    _nomLivre = value;
  }

  /// Crée un objet Livre à partir d'un Map (base de données).
  factory Livre.fromMap(Map<String, dynamic> map) {
    return Livre(
      idLivre: map['idLivre'],
      nomLivre: map['nomLivre'],
      auteur: Auteur.fromMap(map),
    );
  }
}
