import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';
import '../../model/Genre.dart';

class ModifierGenreView extends StatefulWidget {
  final Genre genre;

  const ModifierGenreView({Key? key, required this.genre}) : super(key: key);

  @override
  State<ModifierGenreView> createState() => _ModifierGenreViewState();
}

class _ModifierGenreViewState extends State<ModifierGenreView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomGenreController;

  @override
  void initState() {
    super.initState();
    _nomGenreController = TextEditingController(text: widget.genre.nomGenre);
  }

  @override
  void dispose() {
    _nomGenreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un Genre'),
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
                decoration: const InputDecoration(labelText: "Nom de l'Genre"),
                validator: (value) =>
                value == null || value.isEmpty ? "Veuillez entrer un nom d'genre" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _mettreAJourGenre,
                child: const Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mettreAJourGenre() {
    if (_formKey.currentState!.validate()) {
      Provider.of<GenreViewModel>(context, listen: false)
          .mettreAJourGenre(widget.genre.idGenre!, _nomGenreController.text);
      Navigator.pop(context);
    }
  }
}