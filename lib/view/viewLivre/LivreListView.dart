import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../../model/Livre.dart';
import '../widget/Cards.dart';
import '../widget/ConnectionBanner.dart';

class LivreListView extends StatelessWidget {
  final String userRole;

  const LivreListView({required this.userRole, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<LivreViewModel, UserViewModel>(
      builder: (context, livreViewModel, userViewModel, child) {
        final isAdmin = userViewModel.userRole == 'admin';

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
                userRole: userViewModel.userRole ?? 'user',
                displayJacket: false,
                jacketPath: null,
                onTap: isAdmin
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifierLivreView(livre: livre),
                    ),
                  );
                }
                    : null,
                onDelete: isAdmin
                    ? () => livreViewModel.confirmerSuppressionLivre(context, livre, index)
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
                builder: (context) => const AjouterLivreView(),
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
