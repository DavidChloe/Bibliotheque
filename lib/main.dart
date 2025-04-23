import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/viewUser/LoginView.dart';
import 'view/viewLivre/LivreListView.dart';
import 'viewmodel/viewModelUser/UserViewModel.dart';
import 'viewmodel/viewModelLivre/LivreViewModel.dart';
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart';
import 'viewmodel/viewModelGenre/GenreViewModel.dart';
import 'view/HomeScreen.dart';
import 'view/viewAuteur/AuteurListView.dart';
import 'view/viewGenre/GenreListView.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => LivreViewModel()),
        ChangeNotifierProvider(create: (_) => AuteurViewModel()),
        ChangeNotifierProvider(create: (_) => GenreViewModel()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestion des Utilisateurs',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginView(),
          '/home': (context) => HomeScreen(),

          '/books': (context) {
            final userRole = Provider.of<UserViewModel>(context, listen: false).userRole;
            return LivreListView(userRole: userRole ?? 'user');
          },

          '/authors': (context) => AuteurListView(),
          '/genres': (context) => GenreListView(),
        },
      ),
    );
  }
}
