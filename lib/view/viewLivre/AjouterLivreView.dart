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
    // Charger la liste des auteurs une fois la vue affichée
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LivreViewModel>(context, listen: false).chargerAuteurs();
    });
  }

  @override
  void dispose() {
    _nomLivreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Livre'),
        backgroundColor: Colors.blue[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ nom du livre
              TextFormField(
                controller: _nomLivreController,
                decoration: const InputDecoration(
                  labelText: 'Nom du Livre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.trim().isEmpty
                    ? 'Veuillez entrer le nom du livre'
                    : null,
              ),
              const SizedBox(height: 16),

              // Dropdown des auteurs
              Consumer<LivreViewModel>(
                builder: (context, vm, _) {
                  final auteurs = vm.auteurs;

                  if (auteurs.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: const InputDecoration(
                      labelText: 'Sélectionner un auteur',
                      border: OutlineInputBorder(),
                    ),
                    items: auteurs.map((auteur) {
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

              // Bouton Ajouter
              ElevatedButton(
                onPressed: _soumettreFormulaire,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Ajouter le Livre'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _soumettreFormulaire() async {
    if (_formKey.currentState!.validate()) {
      final nom = _nomLivreController.text.trim();
      final idAuteur = _selectedAuteurId!;

      final livreViewModel = Provider.of<LivreViewModel>(context, listen: false);

      try {
        await livreViewModel.ajouterLivre(nom, idAuteur);
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
}
