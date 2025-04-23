/// @file HomeScreen.dart
/// @brief Page d'accueil post-authentification avec accès aux livres et auteurs.

import 'package:flutter/material.dart';
import 'viewAuteur/AuteurListView.dart';
import 'viewLivre/LivreListView.dart';
import 'widget/ConnectionBanner.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        backgroundColor: Colors.blue[200],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/books');
              },
              icon: Icon(Icons.book),
              label: Text("Accès aux livres"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/authors');
              },
              icon: Icon(Icons.person),
              label: Text("Accès aux auteurs"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/genres');
              },
              icon: Icon(Icons.edit),
              label: Text("Accès aux genres"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ConnectionBanner(),
    );
  }
}