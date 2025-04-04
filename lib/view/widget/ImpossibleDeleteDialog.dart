import 'package:flutter/material.dart';

class ImpossibleDeleteDialog extends StatelessWidget {
  final String title;
  final String content;

  // Utilisation du constructeur avec paramètres nommés pour plus de clarté
  const ImpossibleDeleteDialog({
    Key? key, // Ajout de la clé pour une meilleure performance
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.black54)),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Text(content, style: const TextStyle(color: Colors.black54)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Simplification de la fermeture
          child: const Text('Annuler'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          ),
        ),
      ],
    );
  }
}