import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Auteur.dart';

class ModifierAuteurView extends StatefulWidget {
  final Auteur auteur;

  const ModifierAuteurView({Key? key, required this.auteur}) : super(key: key);

  @override
  State<ModifierAuteurView> createState() => _ModifierAuteurViewState();
}

class _ModifierAuteurViewState extends State<ModifierAuteurView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomAuteurController;

  @override
  void initState() {
    super.initState();
    _nomAuteurController = TextEditingController(text: widget.auteur.nomAuteur);
  }

  @override
  void dispose() {
    _nomAuteurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Modifier l'Auteur")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomAuteurController,
                decoration: const InputDecoration(labelText: "Nom de l'Auteur"),
                validator: (value) =>
                value == null || value.isEmpty ? "Veuillez entrer un nom d'auteur" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _mettreAJourAuteur,
                child: const Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mettreAJourAuteur() {
    if (_formKey.currentState!.validate()) {
      Provider.of<AuteurViewModel>(context, listen: false)
          .mettreAJourAuteur(widget.auteur.idAuteur!, _nomAuteurController.text);
      Navigator.pop(context);
    }
  }
}