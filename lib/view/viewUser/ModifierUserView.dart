import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import 'UserFormView.dart';

class ModifierUserView extends StatefulWidget {
  const ModifierUserView({super.key});

  @override
  State<ModifierUserView> createState() => _ModifierUserViewState();
}

class _ModifierUserViewState extends State<ModifierUserView> {
  final _formKey = GlobalKey<FormState>();

  String nom = '';
  String prenom = '';
  String login = '';
  String mdp = '';

  @override
  void initState() {
    super.initState();
    final userVM = Provider.of<UserViewModel>(context, listen: false);
    // On cherche l'utilisateur connecté dans la liste chargée
    final user = userVM.utilisateurs.firstWhere(
          (u) => u.nomUser == userVM.userName,
      orElse: () => throw Exception("Utilisateur non trouvé"),
    );

    nom = user.nomUser;
    prenom = user.prenomUser;
    login = user.loginUser;
  }

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final isAdmin = userVM.userRole == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text("Modifier Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: nom,
                decoration: const InputDecoration(labelText: "Nom"),
                onChanged: (val) => nom = val,
              ),
              TextFormField(
                initialValue: prenom,
                decoration: const InputDecoration(labelText: "Prénom"),
                onChanged: (val) => prenom = val,
              ),
              TextFormField(
                initialValue: login,
                decoration: const InputDecoration(labelText: "Login"),
                onChanged: (val) => login = val,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: "Mot de passe"),
                onChanged: (val) => mdp = val,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await userVM.updateUser(
                    nom: nom,
                    prenom: prenom,
                    login: login,
                    mdp: mdp,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil mis à jour")),
                    );
                  }
                },
                child: const Text("Sauvegarder"),
              ),
              if (isAdmin) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.group_add),
                  label: const Text("Ajouter un utilisateur"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UserFormView()),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
