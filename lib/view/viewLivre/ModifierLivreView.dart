import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Livre.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LivreViewModel>(context, listen: false).chargerAuteurs();
    });
    _nomLivreController.text = widget.livre.nomLivre;
    _selectedAuteurId = widget.livre.auteur.idAuteur;
  }

  @override
  void dispose() {
    _nomLivreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier un Livre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
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
                    onChanged: (value) => setState(() => _selectedAuteurId = value),
                    validator: (value) =>
                    value == null ? 'Veuillez sélectionner un auteur' : null,
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _modifierLivre,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _modifierLivre() {
    if (_formKey.currentState!.validate()) {
      try {
        final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);
        livreViewModel.mettreAJourLivre(
          widget.livre.idLivre!,
          _nomLivreController.text,
          _selectedAuteurId!,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livre modifié avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la modification : $e")),
        );
      }
    }
  }
}
