import 'dart:io'; // Pour accéder les images locales
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? jacketPath;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String? userRole;
  final bool displayJacket;

  const CustomCard({
    required this.title,
    required this.subtitle,
    this.jacketPath,
    this.onTap,
    this.onDelete,
    this.userRole,
    this.displayJacket = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[350],
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: displayJacket && jacketPath != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(jacketPath!),
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error,
                size: 50,
                color: Colors.red,
              );
            },
          ),
        )
            : null,
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: () {
          if (userRole == 'admin' && onTap != null) {
            onTap!(); // Seuls les admins peuvent utiliser onTap
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vous n\'avez pas les droits de modifications.'),
              ),
            );
          }
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userRole == 'admin' && onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.blue),
                onPressed: onDelete, // Appeler la fonction onDelete directement
              ),
          ],
        ),
      ),
    );
  }
}
