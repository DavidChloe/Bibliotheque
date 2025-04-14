import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../viewUser/ModifierUserView.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = Provider.of<UserViewModel>(context);
    final nom = userVM.userName ?? 'Utilisateur';
    final role = userVM.userRole ?? 'inconnu';

    return Container(
      color: Colors.blue[200],
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
        children: [
          Text(
            "Connecté en tant que : $nom ($role)",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center, // Centrage du texte
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centrage des boutons
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Modifier"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ModifierUserView()),
                  );
                },
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Déconnexion"),
                onPressed: () async {
                  await userVM.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
