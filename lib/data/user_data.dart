import 'dart:convert';

class UserData {
  // Liste des utilisateurs enregistrés
  static final List<Map<String, dynamic>> users = [];

  // Utilisateur actuellement connecté
  static String? emailConnecte;
  static String? prenomConnecte;

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
      (user) => user['email'].toString().toLowerCase() == email.toLowerCase(),
    );
  }

  // Vérifier les identifiants de connexion
  static bool login(String email, String password) {
    final emailNormalise = email.toLowerCase();

    for (final user in users) {
      if (user['email'].toString().toLowerCase() == emailNormalise &&
          user['password'] == password) {
        emailConnecte = emailNormalise;
        prenomConnecte = user['prenom']?.toString();
        return true;
      }
    }

    return false;
  }

  // Déconnexion
  static void deconnecter() {
    emailConnecte = null;
    prenomConnecte = null;
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
