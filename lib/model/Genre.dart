class Genre {
  final int? idGenre;
  final String nomGenre;

  Genre({
    this.idGenre,
    required this.nomGenre,
  });

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      idGenre: map['idGenre'] as int?,
      nomGenre: map['nomGenre'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idGenre': idGenre,
      'nomGenre': nomGenre,
    };
  }

  Genre copyWith({
    int? idGenre,
    String? nomGenre,
  }) {
    return Genre(
      idGenre: idGenre ?? this.idGenre,
      nomGenre: nomGenre ?? this.nomGenre,
    );
  }
}