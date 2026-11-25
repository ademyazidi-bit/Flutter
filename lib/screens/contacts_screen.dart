import 'package:flutter/material.dart';

import '../data/contact_data.dart';
import '../data/user_data.dart';
import '../models/contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void _seDeconnecter() {
    UserData.deconnecter();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _confirmerSuppression(Contact contact) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirme != true) {
      return;
    }

    final email = UserData.emailConnecte;
    if (email == null) {
      return;
    }

    ContactData.supprimerContact(email, contact.id);
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Contact supprimé')));
  }

  Future<void> _ouvrirFormulaire({Contact? contact}) async {
    await Navigator.pushNamed(context, '/contact-form', arguments: contact);
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final email = UserData.emailConnecte;
    if (email == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final contacts = ContactData.getContacts(email);
    final prenom = UserData.prenomConnecte;
    final titre = prenom == null || prenom.isEmpty
        ? 'Mes Contacts'
        : 'Contacts de $prenom';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(titre),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: _seDeconnecter,
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Text(
                'Aucun contact. Appuyez sur + pour en ajouter.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final premiereLettre = contact.prenom.isEmpty
                    ? ''
                    : contact.prenom[0].toUpperCase();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        premiereLettre,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('${contact.prenom} ${contact.nom}'),
                    subtitle: Text(contact.telephone),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmerSuppression(contact),
                    ),
                    onTap: () => _ouvrirFormulaire(contact: contact),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
