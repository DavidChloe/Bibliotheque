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

class AuteurViewModel with ChangeNotifier {
  final AuteurDatabase _auteurDb = AuteurDatabase();
  List<Auteur> _auteurs = [];

  List<Auteur> get auteurs => _auteurs;

  // Récupérer la liste des auteurs
  Future<void> chargerAuteurs() async {
    final List<Map<String, dynamic>> auteursMap = await _auteurDb.obtenirTousLesAuteurs();
    _auteurs = auteursMap.map((map) => Auteur.fromMap(map)).toList();
    notifyListeners(); // Notifie la vue des changements
  }


  // Ajouter un nouvel auteur
  Future<void> ajouterAuteur(String nomAuteur) async {
    await _auteurDb.ajouterAuteur(nomAuteur);
    await chargerAuteurs(); // Recharger les auteurs après ajout
  }

  // Mettre à jour un auteur existant
  Future<void> mettreAJourAuteur(int idAuteur, String nomAuteur) async {
    await _auteurDb.mettreAJourAuteur(idAuteur, nomAuteur);
    await chargerAuteurs(); // Recharger les auteurs après modification
  }

  // Supprimer un auteur
  Future<void> supprimerAuteur(int idAuteur) async {
    await _auteurDb.supprimerAuteur(idAuteur);
    await chargerAuteurs(); // Recharger les auteurs après suppression
  }


}

