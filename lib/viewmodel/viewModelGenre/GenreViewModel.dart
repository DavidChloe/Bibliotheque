import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/GenreDatabase.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';
import '../../model/Genre.dart';
import '../../view/widget/ConfirmDeleteDialog.dart';

/* [GenreViewModel] est un [ChangeNotifier] qui gère l'état et les opérations liées aux genres.
Cette classe fournit des méthodes pour récupérer, ajouter, mettre à jour,
et supprimer des genres dans la base de données. Elle utilise un modèle
de notification pour informer les widgets consommateurs lorsque les données changent.*/

class GenreViewModel with ChangeNotifier {   // Instance de [GenreDatabase] utilisée pour interagir avec la base de données des genres.
  final GenreDatabase _genreDb = GenreDatabase();
  List<Genre> _genres = [];

  //Retourne une liste d'objets [Genre].
  List<Genre> get genres => _genres;

  Future<void> chargerGenres() async {
    final List<Map<String, dynamic>> genresMap = await _genreDb.obtenirTousLesGenres();
    _genres = genresMap.map((map) => Genre.fromMap(map)).toList();
    notifyListeners(); // Notifie les widgets consommateurs des changements
  }

  Future<void> ajouterGenre(String nomGenre) async {
    await _genreDb.ajouterGenre(nomGenre);
    await chargerGenres(); // Recharge les genres après ajout
  }

  Future<void> mettreAJourGenre(int idGenre, String nomGenre) async {
    await _genreDb.mettreAJourGenre(idGenre, nomGenre);
    await chargerGenres(); // Recharge les genres après modification
  }



  void confirmerSuppressionGenre(BuildContext context, Genre genre, int index) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Confirmer la suppression',
        content: 'Êtes-vous sûr de vouloir supprimer le genre "${genre.nomGenre}" ?',
        onConfirm: () async {
          await supprimerGenre(genre.idGenre!);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Genre supprimé avec succès')),
            );
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }
  /// Supprime un genre de la base de données et recharge la liste des genres.
  ///puis appelle [chargerGenres] pour refléter les changements dans l'état local.
  Future<void> supprimerGenre(int idGenre) async {
    await _genreDb.supprimerGenre(idGenre);
    await chargerGenres(); // Recharge les genres après suppression
  }
}
