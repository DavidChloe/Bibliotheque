import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LivreViewModel>(context, listen: false).chargerAuteurs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un Livre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                builder: (context, livreViewModel, child) {
                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: const InputDecoration(
                      labelText: 'Auteur',
                      border: OutlineInputBorder(),
                    ),
                    items: livreViewModel.auteurs.map((auteur) {
                      return DropdownMenuItem<int>(
                        value: auteur.idAuteur,
                        child: Text(auteur.nomAuteur),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedAuteurId = value);
                    },
                    validator: (value) =>
                    value == null ? 'Veuillez sélectionner un auteur' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _ajouterLivre,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ajouterLivre() {
    if (_formKey.currentState!.validate()) {
      try {
        final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
        livreViewModel.ajouterLivre(
          _nomLivreController.text,
          _selectedAuteurId!,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livre ajouté avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout : $e")),
        );
      }
    }
  }
}
