import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/viewModelUser/UserViewModel.dart';
import '../../model/user.dart';

class UserFormView extends StatefulWidget {
  final User? user;

  const UserFormView({Key? key, this.user}) : super(key: key);

  @override
  _UserFormViewState createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'user'; // Default role
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _isEditing = true;
      _userNameController.text = widget.user!.userName;
      _role = widget.user!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit User' : 'Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: ['admin', 'user'].map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _role = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userName = _userNameController.text;
                final password = _passwordController.text;
                final userViewModel = Provider.of<UserViewModel>(context, listen: false);

                if (_isEditing) {
                  // Update existing user
                  final updatedUser = User(
                    id: widget.user!.id,
                    userName: userName,
                    passwordHash: widget.user!.passwordHash, // Keep the existing hash
                    role: _role,
                  );
                  await userViewModel.updateUser(updatedUser);
                } else {
                  // Register new user
                  await userViewModel.register(userName, password, _role);
                }
                Navigator.pop(context);
              },
              child: Text(_isEditing ? 'Update User' : 'Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
