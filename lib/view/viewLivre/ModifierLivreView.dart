import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Livre.dart';
import '../../viewmodel/viewModelGenre/GenreViewModel.dart';


class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  const ModifierLivreView({super.key, required this.livre});

  @override
  State<ModifierLivreView> createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
  final _formKey = GlobalKey<FormState>();
  final _nomLivreController = TextEditingController();
  int? _selectedAuteurId;
  int? _selectedGenreId;

  String? _jacketPath;

  @override
  void initState() {
    super.initState();
    _nomLivreController.text = widget.livre.nomLivre;
    _selectedAuteurId = widget.livre.idAuteur;
    _jacketPath = widget.livre.jacketPath;

    // Charger les auteurs sans bloquer le build
    Future.delayed(Duration.zero, () {
      Provider.of<LivreViewModel>(context, listen: false).chargerAuteurs();
    });
  }

  @override
  void dispose() {
    _nomLivreController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 75);

    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = p.basename(picked.path);
      final savedPath = p.join(directory.path, fileName);
      await picked.saveTo(savedPath);

      setState(() {
        _jacketPath = savedPath;
      });
    }
  }

  Future<void> _modifierLivre() async {
    if (_formKey.currentState!.validate()) {
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
      try {
        await livreViewModel.mettreAJourLivre(
          widget.livre.idLivre!,
          _nomLivreController.text,
          _selectedAuteurId!,
          jacketPath: _jacketPath,
        );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Livre modifié avec succès')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur : $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePreview = _jacketPath != null && File(_jacketPath!).existsSync()
        ? Image.file(File(_jacketPath!), width: 100, height: 150, fit: BoxFit.cover)
        : Container(
      width: 100,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.book, size: 60, color: Colors.blueGrey),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un Livre'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(child: imagePreview),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Caméra'),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galerie'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomLivreController,
                decoration: const InputDecoration(
                  labelText: 'Nom du Livre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              const SizedBox(height: 16),
              Consumer<LivreViewModel>(
                builder: (context, livreViewModel, _) {
                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: const InputDecoration(
                      labelText: 'Auteur',
                      border: OutlineInputBorder(),
                    ),
                    items: livreViewModel.auteurs.map((auteur) {
                      return DropdownMenuItem(
                        value: auteur.idAuteur,
                        child: Text(auteur.nomAuteur),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _selectedAuteurId = value;
                    }),
                    validator: (value) =>
                    value == null ? 'Veuillez sélectionner un auteur' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Consumer<GenreViewModel>(
                builder: (context, vm, _) {
                  return DropdownButtonFormField<int>(
                    value: _selectedGenreId,
                    decoration: const InputDecoration(
                      labelText: 'Genre',
                      border: OutlineInputBorder(),
                    ),
                    items: vm.genres.map((genre) {
                      return DropdownMenuItem<int>(
                        value: genre.idGenre,
                        child: Text(genre.nomGenre),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _selectedGenreId = value;
                    }),
                    validator: (value) =>
                    value == null ? 'Veuillez sélectionner un genre' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _modifierLivre,
                child: const Text('Modifier'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
