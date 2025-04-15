import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';

class AjouterLivreView extends StatefulWidget {
  const AjouterLivreView({super.key});

  @override
  State<AjouterLivreView> createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  final _nomLivreController = TextEditingController();
  int? _selectedAuteurId;
  String? _jacketPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<void> _soumettreFormulaire() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomLivreController.text.trim();
      final idAuteur = _selectedAuteurId!;
      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);

      try {
        await livreViewModel.ajouterLivre(nom, idAuteur, jacketPath: _jacketPath);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Livre ajouté avec succès')),
          );
        }
      } catch (e) {
        debugPrint('Erreur ajout livre: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'ajout du livre')),
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
        title: const Text('Ajouter un Livre'),
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
                value == null || value.isEmpty ? 'Veuillez entrer le nom du livre' : null,
              ),
              const SizedBox(height: 16),
              Consumer<LivreViewModel>(
                builder: (context, vm, _) {
                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: const InputDecoration(
                      labelText: 'Auteur',
                      border: OutlineInputBorder(),
                    ),
                    items: vm.auteurs.map((auteur) {
                      return DropdownMenuItem<int>(
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _soumettreFormulaire,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Ajouter le Livre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
