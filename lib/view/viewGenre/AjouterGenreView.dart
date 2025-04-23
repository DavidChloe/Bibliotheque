import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';

class AjouterGenreView extends StatefulWidget {
  const AjouterGenreView({Key? key}) : super(key: key);

  @override
  State<AjouterGenreView> createState() => _AjouterGenreViewState();
}

class _AjouterGenreViewState extends State<AjouterGenreView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomGenreController = TextEditingController();

  @override
  void dispose() {
    _nomGenreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ajouter un Genre'),
    backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomGenreController,
                decoration: const InputDecoration(labelText: 'Nom du Genre'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Veuillez entrer un nom de genre' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _ajouterGenre,
                child: const Text('Ajouter le genre'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouterGenre() {
    if (_formKey.currentState!.validate()) {
      Provider.of<GenreViewModel>(context, listen: false)
          .ajouterGenre(_nomGenreController.text);
      Navigator.pop(context);
    }
  }
}