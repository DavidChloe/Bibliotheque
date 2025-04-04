import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../model/Livre.dart';

class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  ModifierLivreView({required this.livre});

  @override
  _ModifierLivreViewState createState() => _ModifierLivreViewState();
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nomLivreController.text = widget.livre.nomLivre; // Use widget.livre
    _selectedAuteurId = widget.livre.auteur.idAuteur; // Use widget.livre
  }

  @override
  void dispose() {
    _nomLivreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier un Livre')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomLivreController,
                decoration: InputDecoration(
                  labelText: 'Nom du Livre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du livre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Consumer<LivreViewModel>(
                builder: (context, livreViewModel, child) {
                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: InputDecoration(
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
                      setState(() {
                        _selectedAuteurId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Veuillez sélectionner un auteur';
                      }
                      return null;
                    },
                  );
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _modifierLivre,
                child: Text('Modifier'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
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
          widget.livre.idLivre!, // Utilisez l'ID du livre existant
          _nomLivreController.text,
          _selectedAuteurId!,
        );
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Livre modifié avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la modification du livre: $e')),
        );
      }
    }
  }
}