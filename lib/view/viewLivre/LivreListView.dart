import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import 'AjouterLivreView.dart';
import 'ModifierLivreView.dart';
import '../../model/Livre.dart';

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
                      icon: Icon(Icons.delete, color:Colors.deepOrange),
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
