import 'package:flutter/material.dart';

/// Un widget représentant une boîte de dialogue pour confirmer ou annuler
/// une suppression.
///
/// Cette boîte de dialogue affiche un titre, un contenu explicatif,
/// ainsi que deux boutons : "Annuler" et "Supprimer".
class ConfirmDeleteDialog extends StatelessWidget {
  /// Le titre de la boîte de dialogue.
  final String title;

  /// Le contenu explicatif affiché dans la boîte de dialogue.
  final String content;

  /// Action à exécuter lorsque l'utilisateur confirme la suppression.
  final VoidCallback onConfirm;

  /// Action à exécuter lorsque l'utilisateur annule la suppression.
  final VoidCallback onCancel;

  /// Crée une instance de [ConfirmDeleteDialog].
  ///
  /// - [title] : Le titre de la boîte de dialogue (obligatoire).
  /// - [content] : Le contenu explicatif (obligatoire).
  /// - [onConfirm] : La fonction appelée lorsque l'utilisateur appuie sur "Supprimer" (obligatoire).
  /// - [onCancel] : La fonction appelée lorsque l'utilisateur appuie sur "Annuler" (obligatoire).
  ConfirmDeleteDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      /// Affiche le titre avec un style gris.
      title: Text(
        title,
        style: const TextStyle(color: Colors.black54),
      ),

      /// Fond blanc pour la boîte de dialogue.
      backgroundColor: Colors.white,

      /// Forme arrondie avec un rayon de bordure de 15.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      /// Contenu explicatif avec un style gris.
      content: Text(
        content,
        style: const TextStyle(color: Colors.black54),
      ),

      /// Actions disponibles dans la boîte de dialogue ("Annuler" et "Supprimer").
      actions: [
        // Bouton "Annuler"
        TextButton(
          onPressed: onCancel,
          child: const Text('Annuler'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          ),
        ),

        // Bouton "Supprimer"
        TextButton(
          onPressed: onConfirm,
          child: const Text('Supprimer'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
        ),
      ],
    );
  }
}
