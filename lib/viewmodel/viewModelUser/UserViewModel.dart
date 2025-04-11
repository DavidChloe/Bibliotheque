import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../model/User.dart';
import '../../model/User.dart';

import '../../repository/UserDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewModel extends ChangeNotifier {
  User? _currentUser;
  final UserDatabase _userDatabase = UserDatabase();

  User? get currentUser => _currentUser;

  Future<bool> login(String userName, String password) async {
    final user = await _userDatabase.getUserByUsername(userName);
    if (user != null) {
      final passwordHash = _hashPassword(password);
      if (user.passwordHash == passwordHash) {
        _currentUser = user;
        // Stocker l'état de connexion
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    // Supprimer l'état de connexion
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }


  Future<bool> register(String userName, String password, String role) async {
    // Vérifier si l'utilisateur existe déjà
    final existingUser = await _userDatabase.getUserByUsername(userName);
    if (existingUser != null) {
      return false; // L'utilisateur existe déjà
    }

    final passwordHash = _hashPassword(password);
    final newUser = User(userName: userName, passwordHash: passwordHash, role: role);
    await _userDatabase.addUser(newUser);
    return true;
  }

  Future<void> updateUser(User user) async {
    await _userDatabase.updateUser(user);
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    await _userDatabase.deleteUser(id);
    notifyListeners();
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
