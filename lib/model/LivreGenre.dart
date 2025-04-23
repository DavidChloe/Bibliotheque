class LivreGenre {
  final int? id; // Clé primaire optionnelle
  final int idLivre;
  final int idGenre;

  LivreGenre({
    this.id,
    required this.idLivre,
    required this.idGenre,
  });

  // Convertit en Map pour insérer dans la base
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idLivre': idLivre,
      'idGenre': idGenre,
    };
  }

  // Crée une instance à partir d'une Map (depuis la base)
  factory LivreGenre.fromMap(Map<String, dynamic> map) {
    return LivreGenre(
      id: map['id'],
      idLivre: map['idLivre'],
      idGenre: map['idGenre'],
    );
  }
}
