import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/Genre.dart';
import '../widget/Cards.dart';
import 'AjouterGenreView.dart';
import 'ModifierGenreView.dart';
import '../widget/ConnectionBanner.dart';


class GenreListView extends StatelessWidget {
  const GenreListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<GenreViewModel, LivreViewModel, UserViewModel>(
      builder: (context, genreViewModel, livreViewModel, userViewModel, child) {
        final isAdmin = userViewModel.userRole == 'admin';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Liste des Genres'),
            backgroundColor: Colors.blue[200],
          ),
          body: ListView.builder(
            itemCount: genreViewModel.genres.length,
            itemBuilder: (context, index) {
              final Genre genre = genreViewModel.genres[index];
              return CustomCard(
                title: genre.nomGenre,
                subtitle: 'Type de genre',
                userRole: userViewModel.userRole ?? 'user', // Pour appliquer les restrictions dans la carte
                onTap: isAdmin
                    ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierGenreView(genre: genre),
                  ),
                )
                    : null,
                onDelete: () {
                  genreViewModel.confirmerSuppressionGenre(
                      context, genre, index);
                },
              );
            },
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AjouterGenreView(),
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
