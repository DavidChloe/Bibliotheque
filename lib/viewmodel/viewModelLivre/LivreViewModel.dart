import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../repository/LivreDatabase.dart';
import '../../repository/AuteurDatabase.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart'; // <-- Assure-toi que le fichier s'appelle auteur.dart
import '../../model/Livre.dart';
import '../../model/Genre.dart';
import '../../model/LivreGenre.dart';
import '../../view/widget/ConfirmDeleteDialog.dart';
import '../../view/widget/ImpossibleDeleteDialog.dart';

class LivreViewModel extends ChangeNotifier {
  final LivreDatabase _db = LivreDatabase();
  final AuteurDatabase _auteurDb = AuteurDatabase();

  List<Livre> _livres = [];
  List<Auteur> _auteurs = [];

  List<Livre> get livres => _livres;
  List<Auteur> get auteurs => _auteurs;

  Future<void> chargerLivres() async {
    try {
      final livresMaps = await _db.obtenirTousLesLivresAvecNomAuteur();
      _livres = livresMaps.map((map) {
        final auteur = Auteur(
          idAuteur: map['auteurId'], // ← C'est bien "auteurId" grâce au AS dans ta requête SQL
          nomAuteur: map['nomAuteur'],
        );

        return Livre.fromMap(map, auteur);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des livres : $e');
    }
  }

  Future<void> chargerAuteurs() async {
    try {
      final auteursMaps = await _auteurDb.obtenirTousLesAuteurs();
      _auteurs = auteursMaps.map((map) => Auteur.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des auteurs : $e');
    }
  }

  Future<void> ajouterLivre(String nomLivre, int idAuteur, {String? jacketPath}) async {
    await _db.ajouterLivre(nomLivre, idAuteur, jacketPath: jacketPath);
    await chargerLivres();
  }

  Future<void> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur, {String? jacketPath}) async {
    await _db.mettreAJourLivre(idLivre, nomLivre, idAuteur, jacketPath: jacketPath);
    await chargerLivres();
  }

  Future<void> supprimerLivre(int idLivre) async {
    await _db.supprimerLivre(idLivre);
    await chargerLivres();
  }

  Future<bool> auteurADesLivres(int idAuteur) async {
    final livres = await _db.obtenirLivresParAuteur(idAuteur);
    return livres.isNotEmpty;
  }

  Future<void> verifierEtConfirmerSuppression(
      BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) async {
    final aDesLivres = await auteurADesLivres(auteur.idAuteur!);
    if (aDesLivres) {
      _afficherPopUpErreur(context, auteur);
    } else {
      _confirmerSuppressionAuteur(context, auteurViewModel, auteur);
    }
  }

  void _afficherPopUpErreur(BuildContext context, Auteur auteur) {
    showDialog(
      context: context,
      builder: (_) => ImpossibleDeleteDialog(
        title: 'Suppression impossible',
        content: 'L\'auteur "${auteur.nomAuteur}" ne peut pas être supprimé car il possède des livres associés.',
      ),
    );
  }

  void confirmerSuppressionLivre(BuildContext context, Livre livre, int index) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Confirmer la suppression',
        content: 'Êtes-vous sûr de vouloir supprimer le livre "${livre.nomLivre}" ?',
        onConfirm: () async {
          await supprimerLivre(livre.idLivre!);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Livre supprimé avec succès')),
            );
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _confirmerSuppressionAuteur(BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Confirmer la suppression',
        content: 'Êtes-vous sûr de vouloir supprimer l\'auteur "${auteur.nomAuteur}" ?',
        onConfirm: () async {
          await auteurViewModel.supprimerAuteur(auteur.idAuteur!);
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Auteur supprimé avec succès')),
            );
          }
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> associerLivreGenre(int livreId, int genreId) async {
    final db = await _db.database;  // Utilisation correcte de l'instance de base de données
    await db.insert('LIVREGENRE', {
      'idLivre': livreId,
      'idGenre': genreId,
    });
  }


}
