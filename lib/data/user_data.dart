import 'dart:convert';

class UserData {
  // Liste des utilisateurs enregistrés
  static final List<Map<String, dynamic>> users = [];

  // Ajouter un utilisateur
  static void addUser(
    String prenom,
    String nom,
    String email,
    String password,
  ) {
    users.add({
      'id': users.length + 1,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'password': password,
    });
  }

  // Vérifier si un email existe déjà
  static bool emailExists(String email) {
    return users.any(
      (user) =>
          user['email'].toString().toLowerCase() ==
          email.toLowerCase(),
    );
  }

  // Vérifier les identifiants de connexion
  static bool login(String email, String password) {
    return users.any(
      (user) =>
          user['email'].toString().toLowerCase() ==
              email.toLowerCase() &&
          user['password'] == password,
    );
  }

  // Générer une liste JSON sans mots de passe
  static String getUsersJson() {
    final contacts = users.map((user) {
      return {
        'id': user['id'],
        'prenom': user['prenom'],
        'nom': user['nom'],
        'email': user['email'],
      };
    }).toList();

    return jsonEncode(contacts);
  }
}