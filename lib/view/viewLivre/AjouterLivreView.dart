import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelLivre/LivreViewModel.dart';
import '../../viewmodel/viewModelAuteur/AuteurViewModel.dart';
import '../../model/Livre.dart';

class AjouterLivreView extends StatefulWidget {
  @override
  _AjouterLivreViewState createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  final _nomLivreController = TextEditingController();
  int? _selectedAuteurId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuteurViewModel>(context, listen: false).chargerAuteurs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un Livre')),
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
              Consumer<AuteurViewModel>(
                builder: (context, auteurViewModel, child) {
                  return DropdownButtonFormField<int>(
                    value: _selectedAuteurId,
                    decoration: InputDecoration(
                      labelText: 'Auteur',
                      border: OutlineInputBorder(),
                    ),
                    items: auteurViewModel.auteurs.map((auteur) {
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
                onPressed: _ajouterLivre,
                child: Text('Ajouter'),
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
          SnackBar(content: Text('Livre ajouté avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout du livre: $e')),
        );
      }
    }
  }
}