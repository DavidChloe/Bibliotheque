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

/// [AuteurViewModel] est un [ChangeNotifier] qui gère l'état et les opérations
/// liées aux auteurs.
///
/// Cette classe fournit des méthodes pour récupérer, ajouter, mettre à jour,
/// et supprimer des auteurs dans la base de données. Elle utilise un modèle
/// de notification pour informer les widgets consommateurs lorsque les données
/// changent.
class AuteurViewModel with ChangeNotifier {
  /// Instance de [AuteurDatabase] utilisée pour interagir avec la base de données des auteurs.
  final AuteurDatabase _auteurDb = AuteurDatabase();

  /// Liste locale des auteurs.
  ///
  /// Cette liste est mise à jour après chaque opération sur la base de données.
  List<Auteur> _auteurs = [];

  /// Getter pour accéder à la liste des auteurs.
  ///
  /// Retourne une liste d'objets [Auteur].
  List<Auteur> get auteurs => _auteurs;

  /// Récupère la liste des auteurs depuis la base de données et met à jour l'état local.
  ///
  /// Cette méthode effectue une requête à la base de données pour obtenir tous les auteurs,
  /// les convertit en objets [Auteur], puis notifie les listeners pour refléter les changements.
  Future<void> chargerAuteurs() async {
    final List<Map<String, dynamic>> auteursMap = await _auteurDb.obtenirTousLesAuteurs();
    _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
    notifyListeners(); // Notifie les widgets consommateurs des changements
  }

  /// Ajoute un nouvel auteur à la base de données et recharge la liste des auteurs.
  ///
  /// - [nomAuteur] : Le nom de l'auteur à ajouter.
  ///
  /// Cette méthode ajoute un auteur dans la base de données via [_auteurDb],
  /// puis appelle [chargerAuteurs] pour mettre à jour l'état local.
  Future<void> ajouterAuteur(String nomAuteur) async {
    await _auteurDb.ajouterAuteur(nomAuteur);
    await chargerAuteurs(); // Recharge les auteurs après ajout
  }

  /// Met à jour un auteur existant dans la base de données et recharge la liste des auteurs.
  ///
  /// - [idAuteur] : L'identifiant unique de l'auteur à mettre à jour.
  /// - [nomAuteur] : Le nouveau nom de l'auteur.
  ///
  /// Cette méthode modifie un auteur dans la base de données via [_auteurDb],
  /// puis appelle [chargerAuteurs] pour refléter les modifications dans l'état local.
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
