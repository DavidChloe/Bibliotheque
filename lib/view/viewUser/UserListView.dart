import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/user.dart';
import 'UserFormView.dart';
import 'LoginView.dart';

class UserListView extends StatelessWidget {
  final String? loginSuccessMessage;

  const UserListView({super.key, this.loginSuccessMessage});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (loginSuccessMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginSuccessMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await userViewModel.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginView()),
              );

            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: userViewModel.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.nomUser),
                  subtitle: Text('Rôle : ${user.roleUser}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFormView(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Supprimer l\'utilisateur'),
                              content: const Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
                              actions: [
                                TextButton(
                                  child: const Text('Annuler'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: const Text('Supprimer'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true && user.idUser != null) {
                            await userViewModel.deleteUser(user.idUser!);
                          } else if (user.idUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Impossible de supprimer : ID utilisateur manquant.")),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
