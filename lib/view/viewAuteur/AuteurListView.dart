import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/Auteur.dart';
import '../widget/Cards.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';
import '../widget/ConnectionBanner.dart';
import '../../model/Livre.dart';


class AuteurListView extends StatelessWidget {
  const AuteurListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<AuteurViewModel, LivreViewModel, UserViewModel>(
      builder: (context, auteurViewModel, livreViewModel, userViewModel, child) {
        final isAdmin = userViewModel.userRole == 'admin';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Liste des Auteurs'),
            backgroundColor: Colors.blue[200],
          ),
          body: ListView.builder(
            itemCount: auteurViewModel.auteurs.length,
            itemBuilder: (context, index) {
              final Auteur auteur = auteurViewModel.auteurs[index];
              return CustomCard(
                title: auteur.nomAuteur,
                subtitle: 'Détails de l\'auteur',
                userRole: userViewModel.userRole ?? 'user', // Pour appliquer les restrictions dans la carte
                onTap: isAdmin
                    ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierAuteurView(auteur: auteur),
                  ),
                )
                    : null,
                onDelete: isAdmin
                    ? () => livreViewModel.verifierEtConfirmerSuppression(
                  context,
                  auteurViewModel,
                  auteur, // ✅ On passe bien l'objet ici
                )
                    : null,

              );
            },
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AjouterAuteurView(),
              ),
            ),
          )
              : null,
          bottomNavigationBar: const ConnectionBanner(),
        );
      },
    );
  }
}
