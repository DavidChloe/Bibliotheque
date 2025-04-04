import 'package:flutter/material.dart';

/// Un widget représentant une boîte de dialogue qui informe l'utilisateur
/// qu'une suppression est impossible.
///
/// Cette boîte de dialogue affiche un titre, un contenu explicatif,
/// et un bouton pour fermer la boîte de dialogue.
class ImpossibleDeleteDialog extends StatelessWidget {
  /// Le titre de la boîte de dialogue.
  final String title;

  /// Le contenu explicatif affiché dans la boîte de dialogue.
  final String content;

  /// Crée une instance de [ImpossibleDeleteDialog].
  ///
  /// - [title] : Le titre de la boîte de dialogue (obligatoire).
  /// - [content] : Le contenu explicatif (obligatoire).
  const ImpossibleDeleteDialog({
    Key? key, // Clé optionnelle pour identifier le widget dans l'arbre.
    required this.title,
    required this.content,
  }) : super(key: key);

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

      /// Actions disponibles dans la boîte de dialogue (bouton "Annuler").
      actions: [
        TextButton(
          /// Ferme la boîte de dialogue en retournant à l'écran précédent.
          onPressed: () => Navigator.of(context).pop(),
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
