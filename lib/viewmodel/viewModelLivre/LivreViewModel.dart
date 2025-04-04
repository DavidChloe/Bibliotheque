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

/// [LivreViewModel] est un [ChangeNotifier] qui gère l'état et les opérations
/// liées aux livres et aux auteurs.
///
/// Cette classe fournit des méthodes pour récupérer, ajouter, mettre à jour,
/// et supprimer des livres dans la base de données. Elle permet également de
/// gérer les relations entre les livres et leurs auteurs.
class LivreViewModel extends ChangeNotifier {
  /// Instance de [LivreDatabase] utilisée pour interagir avec la base de données des livres.
  final LivreDatabase _db = LivreDatabase();

  /// Instance de [AuteurDatabase] utilisée pour interagir avec la base de données des auteurs.
  final AuteurDatabase _auteurDb = AuteurDatabase();

  /// Liste locale des livres.
  ///
  /// Cette liste est mise à jour après chaque opération sur la base de données.
  List<Livre> _livres = [];

  /// Liste locale des auteurs.
  ///
  /// Cette liste est mise à jour après chaque opération sur la base de données.
  List<Auteur> _auteurs = [];

  /// Getter pour accéder à la liste des livres.
  ///
  /// Retourne une liste d'objets [Livre].
  List<Livre> get livres => _livres;

  /// Getter pour accéder à la liste des auteurs.
  ///
  /// Retourne une liste d'objets [Auteur].
  List<Auteur> get auteurs => _auteurs;

  /// Récupère la liste des livres depuis la base de données et met à jour l'état local.
  ///
  /// Cette méthode effectue une requête à la base de données pour obtenir tous les livres
  /// avec le nom de leur auteur, les convertit en objets [Livre], puis notifie les listeners
  /// pour refléter les changements.
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
      notifyListeners(); // Notifie les widgets consommateurs des changements
    } catch (e) {
      print('Error loading books: $e');
    }
  }

  /// Récupère la liste des auteurs depuis la base de données et met à jour l'état local.
  ///
  /// Cette méthode effectue une requête à la base de données pour obtenir tous les auteurs,
  /// les convertit en objets [Auteur], puis notifie les listeners pour refléter les changements.
  Future<void> chargerAuteurs() async {
    try {
      List<Map<String, dynamic>> auteursMaps = await _auteurDb.obtenirTousLesAuteurs();
      _auteurs = auteursMaps.map((map) => Auteur.fromMap(map)).toList();
      notifyListeners(); // Notifie les widgets consommateurs des changements
    } catch (e) {
      print('Error loading authors: $e');
    }
  }

  /// Ajoute un nouveau livre à la base de données et recharge la liste des livres.
  ///
  /// - [nomLivre] : Le nom du livre à ajouter.
  /// - [idAuteur] : L'identifiant unique de l'auteur du livre.
  ///
  /// Cette méthode ajoute un livre dans la base de données via [_db],
  /// puis appelle [chargerLivres] pour mettre à jour l'état local.
  Future<void> ajouterLivre(String nomLivre, int idAuteur) async {
    await _db.ajouterLivre(nomLivre, idAuteur);
    await chargerLivres(); // Recharge les livres après ajout
  }

  /// Met à jour un livre existant dans la base de données et recharge la liste des livres.
  ///
  /// - [idLivre] : L'identifiant unique du livre à mettre à jour.
  /// - [nomLivre] : Le nouveau nom du livre.
  /// - [idAuteur] : L'identifiant unique du nouvel auteur du livre.
  ///
  /// Cette méthode modifie un livre dans la base de données via [_db],
  /// puis appelle [chargerLivres] pour refléter les modifications dans l'état local.
  Future<void> mettreAJourLivre(int idLivre, String nomLivre, int idAuteur) async {
    await _db.mettreAJourLivre(idLivre, nomLivre, idAuteur);
    await chargerLivres(); // Recharge les livres après modification
  }

  /// Supprime un livre de la base de données et recharge la liste des livres.
  ///
  /// - [idLivre] : L'identifiant unique du livre à supprimer.
  ///
  /// Cette méthode supprime un livre dans la base de données via [_db],
  /// puis appelle [chargerLivres] pour refléter les changements dans l'état local.
  Future<void> supprimerLivre(int idLivre) async {
    await _db.supprimerLivre(idLivre);
    await chargerLivres(); // Recharge les livres après suppression
  }

  /// Vérifie si un auteur a des livres associés dans la base de données.
  ///
  /// - [idAuteur] : L'identifiant unique de l'auteur à vérifier.
  ///
  /// Retourne `true` si l'auteur a au moins un livre associé, `false` sinon.
  Future<bool> auteurADesLivres(int idAuteur) async {
    List<Map<String, dynamic>> livres = await _db.obtenirLivresParAuteur(idAuteur);
    return livres.isNotEmpty;
  }

  /// Vérifie si un auteur peut être supprimé et affiche une boîte de dialogue en conséquence.
  ///
  /// - [context] : Le contexte Flutter actuel.
  /// - [auteurViewModel] : Le modèle utilisé pour gérer les auteurs ([AuteurViewModel]).
  /// - [auteur] : L'auteur à vérifier avant suppression.
  Future<void> verifierEtConfirmerSuppression(BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) async {
    bool aDesLivres = await auteurADesLivres(auteur.idAuteur!);

    if (aDesLivres) {
      _afficherPopUpErreur(context, auteur);
    } else {
      _confirmerSuppressionAuteur(context, auteurViewModel, auteur);
    }
  }

  /// Affiche une boîte de dialogue d'erreur indiquant qu'il est impossible
  /// de supprimer l'auteur car il possède des livres associés.
  ///
  /// - [context] : Le contexte Flutter actuel.
  /// - [auteur] : L'auteur concerné par l'erreur.
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

  /// Affiche une boîte de dialogue pour confirmer ou annuler la suppression d'un livre spécifique.
  ///
  /// - [context] : Le contexte Flutter actuel.
  /// - [livre] : Le livre à supprimer.
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

  /// Affiche une boîte de dialogue pour confirmer ou annuler la suppression d'un auteur spécifique.
  ///
  /// - [context] : Le contexte Flutter actuel.
  void _confirmerSuppressionAuteur(BuildContext context, AuteurViewModel auteurViewModel, Auteur auteur) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmDeleteDialog(
          title: 'Confirmer la suppression',
          content: 'Êtes-vous sûr de vouloir supprimer l\'auteur "${auteur.nomAuteur}" ?',
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
