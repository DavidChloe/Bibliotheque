/*import 'package:bibliotheque/view/viewLivre/LivreListView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../view/viewLivre/AjouterLivreView.dart';

/// Ecran d'accueil de l'application Bibliothèque Numérique.
///
/// Cet écran affiche une liste de livres et un menu latéral permettant d'ajouter des livres ou de gérer les auteurs.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les Livres au démarrage
    Future.microtask(() {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      livreViewModel.chargerLivres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bibliothèque Numérique', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 100, // Ajuste la hauteur du DrawerHeader
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: const Padding(
                padding: EdgeInsets.all(32), // Ajuste le padding interne
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: Colors.deepPurple),
              title: const Text('Ajouter un livre'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AjouterLivreView(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Colors.deepPurple),
              title: const Text('Gérer les auteurs'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AuteurListView(),
                ));
              },
            ),
          ],
        ),
      ),
      body: LivreListView(), // Remplacement par la vue LivreListView
    );
  }
}
*/
