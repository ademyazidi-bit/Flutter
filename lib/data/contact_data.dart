import '../models/contact.dart';

class ContactData {
  static final Map<String, List<Contact>> _contactsParUtilisateur = {};
  static int _prochainId = 1;

  static String _normaliserEmail(String email) => email.toLowerCase();

  static List<Contact> getContacts(String email) {
    final contacts = _contactsParUtilisateur[_normaliserEmail(email)] ?? [];
    final liste = List<Contact>.from(contacts);
    liste.sort((a, b) {
      final comparaison = a.prenom.toLowerCase().compareTo(
        b.prenom.toLowerCase(),
      );
      if (comparaison != 0) {
        return comparaison;
      }
      return a.nom.toLowerCase().compareTo(b.nom.toLowerCase());
    });
    return liste;
  }

  static void ajouterContact(
    String email,
    String nom,
    String prenom,
    String telephone,
  ) {
    final emailNormalise = _normaliserEmail(email);
    final contacts = _contactsParUtilisateur.putIfAbsent(
      emailNormalise,
      () => [],
    );
    contacts.add(
      Contact(id: _prochainId, nom: nom, prenom: prenom, telephone: telephone),
    );
    _prochainId++;
  }

  static void modifierContact(
    String email,
    int id,
    String nom,
    String prenom,
    String telephone,
  ) {
    final contacts = _contactsParUtilisateur[_normaliserEmail(email)] ?? [];
    final index = contacts.indexWhere((contact) => contact.id == id);
    if (index == -1) {
      return;
    }

    contacts[index] = Contact(
      id: id,
      nom: nom,
      prenom: prenom,
      telephone: telephone,
    );
  }

  static void supprimerContact(String email, int id) {
    final contacts = _contactsParUtilisateur[_normaliserEmail(email)];
    if (contacts == null) {
      return;
    }
    contacts.removeWhere((contact) => contact.id == id);
  }

  static bool telephoneExiste(
    String email,
    String telephone, {
    int? ignorerId,
  }) {
    final contacts = _contactsParUtilisateur[_normaliserEmail(email)] ?? [];
    return contacts.any(
      (contact) => contact.id != ignorerId && contact.telephone == telephone,
    );
  }
}
