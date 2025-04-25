import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';

import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../../model/Livre.dart';
import '../../model/LivreGenre.dart';

import '../../model/Auteur.dart';
import '../widget/Cards.dart';
import '../widget/ConnectionBanner.dart';

class LivreListView extends StatefulWidget {
  final String userRole;

  const LivreListView({required this.userRole, Key? key}) : super(key: key);

  @override
  State<LivreListView> createState() => _LivreListViewState();
}

class _LivreListViewState extends State<LivreListView> {
  @override
  void initState() {
    super.initState();
    // Charger les livres au démarrage du widget
    Future.microtask(() =>
        Provider.of<LivreViewModel>(context, listen: false).chargerLivres());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LivreViewModel>(
      builder: (context, livreViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Liste des Livres'),
          ),
          body: livreViewModel.livres.isEmpty
              ? const Center(child: Text('Aucun livre trouvé.'))
              : ListView.builder(
            itemCount: livreViewModel.livres.length,
            itemBuilder: (context, index) {
              final Livre livre = livreViewModel.livres[index];
              return CustomCard(
                title: livre.nomLivre,
                subtitle: 'Auteur : ${livre.auteur.nomAuteur}',
                    //Genre : ${}',
                userRole: widget.userRole,
                displayJacket: true,
                jacketPath: livre.jacketPath,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ModifierLivreView(livre: livre),
                    ),
                  );
                },
                onDelete: () {
                  livreViewModel.confirmerSuppressionLivre(
                      context, livre, index);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AjouterLivreView(),
                ),
              );
            },
          ),
          bottomNavigationBar: const ConnectionBanner(),
        );
      },
    );
  }
}
