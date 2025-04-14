import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';

class AjouterAuteurView extends StatefulWidget {
  const AjouterAuteurView({Key? key}) : super(key: key);

  @override
  State<AjouterAuteurView> createState() => _AjouterAuteurViewState();
}

class _AjouterAuteurViewState extends State<AjouterAuteurView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAuteurController = TextEditingController();

  @override
  void dispose() {
    _nomAuteurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ajouter un Auteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomAuteurController,
                decoration: const InputDecoration(labelText: 'Nom de l\'Auteur'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Veuillez entrer un nom d\'auteur' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterAuteur,
                child: const Text('Ajouter l\'auteur'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouterAuteur() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AuteurViewModel>(context, listen: false)
          .ajouterAuteur(_nomAuteurController.text);
      Navigator.pop(context);
    }
  }
}