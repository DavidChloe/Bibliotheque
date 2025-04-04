class Auteur {

  int? _idAuteur = 0;
  String _nomAuteur = '';

  // Constructeur
  Auteur({int? idAuteur, required String? nomAuteur}) {
    _idAuteur = idAuteur;
    _nomAuteur = nomAuteur!;
  }

  // Getters
  int? get idAuteur => _idAuteur;

  String get nomAuteur => _nomAuteur;

  // Setters
  set nomAuteur(String? nomAuteur) {
    _nomAuteur = nomAuteur!;
  }

  // Méthode pour convertir un Auteur en Map (pour la base de données)
  Map<String, dynamic> toMap() {
    return {
      'IdAuteur': _idAuteur,
      'nomAuteur': _nomAuteur,
    };
  }

  // Méthode pour créer un Auteur à partir d'un Map (depuis la base de données)
  factory Auteur.fromMap(Map<String, dynamic> map) {
    return Auteur(
      idAuteur: map['idAuteur'],
      nomAuteur: map['nomAuteur'],
    );
  }


}