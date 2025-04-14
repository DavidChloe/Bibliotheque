import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/viewUser/LoginView.dart';
import 'view/viewLivre/LivreListView.dart';
import 'viewmodel/viewModelUser/UserViewModel.dart';
import 'viewmodel/viewModelLivre/LivreViewModel.dart'; // ✅ import
import 'viewmodel/viewModelAuteur/AuteurViewModel.dart'; // ✅ import
import 'view/HomeScreen.dart';
import 'view/viewAuteur/AuteurListView.dart';

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
        ChangeNotifierProvider(create: (_) => LivreViewModel()), // ✅ ajout
        ChangeNotifierProvider(create: (_) => AuteurViewModel()), // ✅ ajout
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
        },
      ),
    );
  }
}
