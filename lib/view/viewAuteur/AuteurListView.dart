import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Auteur.dart';
import 'AjouterAuteurView.dart';
import 'ModifierAuteurView.dart';

class AuteurListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuteurViewModel>(
      builder: (context, auteurViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Liste des Auteurs'),
          ),
          body: ListView.builder(
            itemCount: auteurViewModel.auteurs.length,
            itemBuilder: (context, index) {
              final Auteur auteur = auteurViewModel.auteurs[index];
              return ListTile(
                title: Text(auteur.nomAuteur),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModifierAuteurView(auteur: auteur),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
                        livreViewModel.verifierEtConfirmerSuppression(context, auteurViewModel, auteur);
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
              MaterialPageRoute(builder: (context) => AjouterAuteurView()),
            ),
          ),
        );
      },
    );
  }
}
