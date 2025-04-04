import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  ConfirmDeleteDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: Colors.black54)),
      backgroundColor: Colors.white, // Fond Blanc
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Angles arrondis
      ),
      content: Text(content, style: TextStyle(color: Colors.black54)),
      actions: [
        // Bouton "Annuler" en bleu
        TextButton(
          onPressed: onCancel,
          child: Text('Annuler'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          ),
        ),
        // Bouton "Supprimer" en rouge
        TextButton(
          onPressed: onConfirm,
          child: Text('Supprimer'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ],
    );
  }
}