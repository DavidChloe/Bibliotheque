import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../model/user.dart';
import '../../repository/Userdatabase.dart';

class UserViewModel with ChangeNotifier {
  final UserDatabase _userDb = UserDatabase();
  List<User> _users = [];
  bool _isLoading = false;
  String? _userName;
  String? _userRole;

  List<User> get utilisateurs => _users;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userRole => _userRole;

  // 🔥 Le getter user ajouté ici
  User? get user {
    if (_userName == null || _userRole == null) return null;
    try {
      return _users.firstWhere(
            (u) => u.nomUser == _userName && u.roleUser == _userRole,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> chargerUtilisateurs() async {
    _isLoading = true;
    notifyListeners();
    _users = await _userDb.obtenirTousLesUtilisateurs();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> ajouterUser({
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDb.ajouterUser(
      nomUser: nomUser,
      prenomUser: prenomUser,
      loginUser: loginUser,
      mdpUser: mdpUser,
      roleUser: roleUser,
    );
    await chargerUtilisateurs();
  }

  Future<void> mettreAJourUser({
    required int idUser,
    required String nomUser,
    required String prenomUser,
    required String loginUser,
    required String mdpUser,
    required String roleUser,
  }) async {
    await _userDb.mettreAJourUser(
      idUser: idUser,
      nomUser: nomUser,
      prenomUser: prenomUser,
      loginUser: loginUser,
      mdpUser: mdpUser,
      roleUser: roleUser,
    );
    await chargerUtilisateurs();
  }

  Future<void> deleteUser(int idUser) async {
    await _userDb.supprimerUser(idUser);
    await chargerUtilisateurs();
  }

  Future<String?> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) return 'Veuillez remplir tous les champs';

    var user = await _userDb.verifierLogin(login, password);

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', user.nomUser);
      await prefs.setString('userRole', user.roleUser);
      _userName = user.nomUser;
      _userRole = user.roleUser;
      await chargerUtilisateurs(); // ← s'assurer que la liste est dispo
      notifyListeners();
      return null;
    } else {
      return 'Login ou mot de passe incorrect';
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userRole');
    _userName = null;
    _userRole = null;
    notifyListeners();
  }

  Future<List<User>> getUsers() async {
    await chargerUtilisateurs();
    return _users;
  }

  Future<void> updateUser({
    required String nom,
    required String prenom,
    required String login,
    required String mdp,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('userRole');
    String? oldNom = prefs.getString('userName');

    if (oldNom == null || role == null) return;

    User? currentUser = _users.firstWhere(
          (u) => u.nomUser == oldNom && u.roleUser == role,
      orElse: () => throw Exception("Utilisateur introuvable"),
    );

    await _userDb.mettreAJourUser(
      idUser: currentUser.idUser!,
      nomUser: nom,
      prenomUser: prenom,
      loginUser: login,
      mdpUser: mdp,
      roleUser: role,
    );

    await prefs.setString('userName', nom);
    _userName = nom;

    await chargerUtilisateurs();
    notifyListeners();
  }

  Future<void> initialiserUtilisateur() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    _userRole = prefs.getString('userRole');
    await chargerUtilisateurs(); // ← Assure que _users est à jour
    notifyListeners();
  }
}
