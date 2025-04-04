import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/LivreDatabase.dart';
import '../../repository/AuteurDatabase.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Auteur.dart';
import '../../model/Livre.dart';
import '../../view/widget/ConfirmDeleteDialog.dart';
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
      List<Map<String, dynamic>> livresMaps = await _db.obtenirTousLesLivresAvecNomAuteur();
      _livres = livresMaps.map((map) => Livre(
        idLivre: map['idLivre'],
        nomLivre: map['nomLivre'],
        auteur: Auteur(
            idAuteur: map['idAuteur'],
            nomAuteur: map['nomAuteur']
        ),
      )).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading books: $e');
    }
  }


  Future<void> chargerAuteurs() async {
    try {
      List<Map<String, dynamic>> auteursMaps = await _auteurDb.obtenirTousLesAuteurs();
      _auteurs = auteursMaps.map((map) => Auteur.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading authors: $e');
    }
  }

  Future<void> ajouterLivre(String nomLivre, int idAuteur) async {
    await _db.ajouterLivre(nomLivre, idAuteur);
    await chargerLivres();
  }

  Future<void> mettreAJourLivre(int idLivre, String nomLivre,
      int idAuteur) async {
    await _db.mettreAJourLivre(idLivre, nomLivre, idAuteur);
    await chargerLivres();
  }

  Future<void> supprimerLivre(int idLivre) async {
    await _db.supprimerLivre(idLivre);
    await chargerLivres();
  }

  Future<bool> auteurADesLivres(int idAuteur) async {
    List<Map<String, dynamic>> livres = await _db.obtenirLivresParAuteur(
        idAuteur);
    return livres.isNotEmpty;
  }

  Future<void> verifierEtConfirmerSuppression(BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) async {
    bool aDesLivres = await auteurADesLivres(auteur.idAuteur!);

    if (aDesLivres) {
      _afficherPopUpErreur(context, auteur);
    } else {
      _confirmerSuppressionAuteur(context, auteurViewModel, auteur);
    }
  }

  void _afficherPopUpErreur(BuildContext context, Auteur auteur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImpossibleDeleteDialog(
          title: 'Suppression impossible',
          content: 'L\'auteur "${auteur.nomAuteur}" ne peut pas être supprimé car il possède un ou plusieurs livres associés.',
        );
      },
    );
  }

  void confirmerSuppressionLivre(BuildContext context, Livre livre, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          title: 'Confirmer la suppression',
          content: 'Êtes-vous sûr de vouloir supprimer ce livre "${livre.nomLivre}" ?',
          onConfirm: () {
            supprimerLivre(livre.idLivre!);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Livre supprimé avec succès')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }


  void _confirmerSuppressionAuteur(BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          title: 'Confirmer la suppression',
          content: 'Êtes-vous sûr de vouloir supprimer l\'auteur "${auteur
              .nomAuteur}" ?',
          onConfirm: () {
            auteurViewModel.supprimerAuteur(auteur.idAuteur!);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Auteur supprimé avec succès')),
            );
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}