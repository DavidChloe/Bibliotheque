import 'dart:io'; // Pour accéder aux images locales
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../../model/Livre.dart';
import '../widget/Cards.dart'; // Import de la classe CustomCard

/// Widget qui affiche une liste de livres.
///
/// Permet de visualiser les livres, les modifier et les supprimer.
class LivreListView extends StatelessWidget {
  final String userRole; // Ajout du rôle utilisateur pour gérer les permissions

  const LivreListView({required this.userRole, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LivreViewModel>(
      builder: (context, livreViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Liste des Livres'),
          ),
          body: ListView.builder(
            itemCount: livreViewModel.livres.length,
            itemBuilder: (context, index) {
              final Livre livre = livreViewModel.livres[index];

              return CustomCard(
                title: livre.nomLivre,
                subtitle: 'Auteur : ${livre.auteur.nomAuteur}',
                jacketPath: null, // Ajoutez un chemin vers l'image si disponible
                userRole: userRole,
                displayJacket: false, // Changez en true si vous souhaitez afficher une image
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierLivreView(livre: livre),
                    ),
                  );
                },
                onDelete: () {
                  livreViewModel.confirmerSuppressionLivre(context, livre, index);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AjouterLivreView()),
            ),
          ),
        );
      },
    );
  }
}
/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../../model/Livre.dart';
import '../widget/Cards.dart';


/// Widget qui affiche une liste de livres.
///
/// Permet de visualiser les livres, les modifier et les supprimer.
class LivreListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LivreViewModel>(
      builder: (context, livreViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Liste des Livres'),
          ),
          body: ListView.builder(
            itemCount: livreViewModel.livres.length,
            itemBuilder: (context, index) {
              final Livre livre = livreViewModel.livres[index];
              return ListTile(
                title: Text(livre.nomLivre),
                subtitle: Text('Auteur: ${livre.auteur.nomAuteur}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifierLivreView(livre: livre),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.deepOrange),
                      onPressed: () {
                        livreViewModel.confirmerSuppressionLivre(context, livre, index);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AjouterLivreView()),
            ),
          ),
        );
      },
    );
  }
}
*/