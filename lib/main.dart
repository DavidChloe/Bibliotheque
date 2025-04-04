/// @file main.dart
/// @brief Point d'entrée de l'application de gestion de bibliothèque.
///
/// Ce fichier initialise l'application Flutter en utilisant MultiProvider pour gérer
/// les ViewModels de `Livre` et `Auteur`, et configure les routes de navigation.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'view/viewAuteur/AuteurListView.dart';
import 'viewmodel/viewModelLivre/LivreViewModel.dart';
import 'view/viewLivre/LivreListView.dart';
import 'view/viewLivre/AjouterLivreView.dart';
import 'view/viewLivre/ModifierLivreView.dart';

/// Fonction principale qui lance l'application.
void main() {
  runApp(MyApp());
}

/// @class MyApp
/// @brief Classe principale de l'application Flutter.
///
/// Cette classe initialise `MultiProvider` pour gérer les `ViewModels`
/// et définit les routes de navigation.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LivreViewModel()),
        ChangeNotifierProvider(create: (context) => AuteurViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestion de Bibliothèque',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
        routes: {
          '/livres': (context) => LivreListView(),
          '/auteurs': (context) => AuteurListView(),
          '/ajouterLivre': (context) => AjouterLivreView(),
          // '/modifierLivre': (context) => ModifierLivreView(),
        },
      ),
    );
  }
}

/// @class HomePage
/// @brief Écran d'accueil de l'application.
///
/// Cette classe affiche un écran d'accueil avec des boutons permettant de naviguer
/// vers la gestion des livres et des auteurs.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de Bibliothèque'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Gestion des Livres'),
              onPressed: () => Navigator.pushNamed(context, '/livres'),
            ),
            SizedBox(height: 28),
            ElevatedButton(
              child: Text('Gestion des Auteurs'),
              onPressed: () => Navigator.pushNamed(context, '/auteurs'),
            ),
          ],
        ),
      ),
    );
  }
}
