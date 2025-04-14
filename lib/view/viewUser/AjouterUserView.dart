import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import 'LoginView.dart';

class AjouterUserView extends StatefulWidget {
  final VoidCallback? onUserCreated;

  const AjouterUserView({Key? key, this.onUserCreated}) : super(key: key);

  @override
  _AjouterUserViewState createState() => _AjouterUserViewState();
}

class _AjouterUserViewState extends State<AjouterUserView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();

  String _selectedRole = 'user';

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      await userViewModel.ajouterUser(
        nomUser: _nomController.text,
        prenomUser: _prenomController.text,
        loginUser: _loginController.text,
        mdpUser: _mdpController.text,
        roleUser: _selectedRole, // ✅ Ajout du rôle ici
      );

      widget.onUserCreated?.call(); // Pour déclencher le callback si défini

      // Redirection vers l'écran de connexion
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un Compte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Entrez un nom' : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value!.isEmpty ? 'Entrez un prénom' : null,
              ),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) => value!.isEmpty ? 'Entrez un login' : null,
              ),
              TextFormField(
                controller: _mdpController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Entrez un mot de passe' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('Utilisateur')),
                  DropdownMenuItem(value: 'admin', child: Text('Administrateur')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Créer le compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
