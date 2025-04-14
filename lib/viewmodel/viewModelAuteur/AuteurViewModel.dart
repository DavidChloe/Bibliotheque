import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repository/LivreDatabase.dart';
import '../../repository/AuteurDatabase.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart';
import '../../model/Livre.dart';
import '../../view/widget/ConfirmDeleteDialog.dart';
import '../../view/widget/ImpossibleDeleteDialog.dart';

/* [AuteurViewModel] est un [ChangeNotifier] qui gère l'état et les opérations liées aux auteurs.
Cette classe fournit des méthodes pour récupérer, ajouter, mettre à jour,
et supprimer des auteurs dans la base de données. Elle utilise un modèle
de notification pour informer les widgets consommateurs lorsque les données changent.*/

class AuteurViewModel with ChangeNotifier {   // Instance de [AuteurDatabase] utilisée pour interagir avec la base de données des auteurs.
  final AuteurDatabase _auteurDb = AuteurDatabase();
  List<Auteur> _auteurs = [];

  //Retourne une liste d'objets [Auteur].
  List<Auteur> get auteurs => _auteurs;

  Future<void> chargerAuteurs() async {
    final List<Map<String, dynamic>> auteursMap = await _auteurDb.obtenirTousLesAuteurs();
    _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
    notifyListeners(); // Notifie les widgets consommateurs des changements
  }

  Future<void> ajouterAuteur(String nomAuteur) async {
    await _auteurDb.ajouterAuteur(nomAuteur);
    await chargerAuteurs(); // Recharge les auteurs après ajout
  }

  Future<void> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    await _auteurDb.mettreAJourAuteur(idAuteur, nomAuteur);
    await chargerAuteurs(); // Recharge les auteurs après modification
  }

  /// Supprime un auteur de la base de données et recharge la liste des auteurs.
  ///
  /// - [idAuteur] : L'identifiant unique de l'auteur à supprimer.
  ///
  /// Cette méthode supprime un auteur dans la base de données via [_auteurDb],
  /// puis appelle [chargerAuteurs] pour refléter les changements dans l'état local.
  Future<void> supprimerAuteur(int idAuteur) async {
    await _auteurDb.supprimerAuteur(idAuteur);
    await chargerAuteurs(); // Recharge les auteurs après suppression
  }
}
