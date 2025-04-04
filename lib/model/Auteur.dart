/// Classe représentant un auteur.
///
/// Chaque auteur a un identifiant unique et un nom associé.
class Auteur {
  int? _idAuteur = 0;
  String _nomAuteur = '';

  /// Constructeur de la classe Auteur.
  ///
  /// [idAuteur] est facultatif, mais [nomAuteur] est requis.
  Auteur({int? idAuteur, required String? nomAuteur}) {
    _idAuteur = idAuteur;
    _nomAuteur = nomAuteur!;
  }

  /// Obtient l'identifiant de l'auteur.
  int? get idAuteur => _idAuteur;

  /// Obtient le nom de l'auteur.
  String get nomAuteur => _nomAuteur;

  /// Modifie le nom de l'auteur.
  set nomAuteur(String? nomAuteur) {
    _nomAuteur = nomAuteur!;
  }

  /// Convertit un auteur en Map pour le stockage en base de données.
  Map<String, dynamic> toMap() {
    return {
      'IdAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
    };
  }

  /// Crée un objet Auteur à partir d'une Map issue de la base de données.
  factory Auteur.fromMap(Map<String, dynamic> map) {
    return Auteur(
      idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
    );
  }
}
