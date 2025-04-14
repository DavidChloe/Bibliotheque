import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../widget/Button.dart';

class UserFormView extends StatefulWidget {
  final User? user;
  const UserFormView({Key? key, this.user}) : super(key: key);

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nomController.text = widget.user!.nomUser;
      _prenomController.text = widget.user!.prenomUser;
      _loginController.text = widget.user!.loginUser;
      _mdpController.text = ''; // Par sécurité
      _role = widget.user!.roleUser;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _loginController.dispose();
    _mdpController.dispose();
    super.dispose();
  }

  void _saveUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      if (widget.user == null) {
        await userViewModel.ajouterUser(
          nomUser: _nomController.text,
          prenomUser: _prenomController.text,
          loginUser: _loginController.text,
          mdpUser: _mdpController.text,
          roleUser: _role,
        );
      } else if (widget.user!.idUser != null) {
        await userViewModel.mettreAJourUser(
          idUser: widget.user!.idUser!,
          nomUser: _nomController.text,
          prenomUser: _prenomController.text,
          loginUser: _loginController.text,
          mdpUser: _mdpController.text.isEmpty
              ? widget.user!.mdpUser
              : _mdpController.text,
          roleUser: _role,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ID utilisateur introuvable pour mise à jour.")),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Ajouter un utilisateur' : 'Modifier utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un prénom' : null,
              ),
              TextFormField(
                controller: _loginController,
                decoration: const InputDecoration(labelText: 'Login'),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer un login' : null,
              ),
              TextFormField(
                controller: _mdpController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (widget.user == null && (value == null || value.isEmpty)) {
                    return 'Veuillez entrer un mot de passe';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  DropdownMenuItem(value: 'user', child: Text('User')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _role = value);
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveUser(context),
                child: Text(widget.user == null ? 'Ajouter' : 'Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
