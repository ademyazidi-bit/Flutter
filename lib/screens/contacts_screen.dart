import 'package:flutter/material.dart';
import '../data/user_data.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // Liste des contacts filtrée par recherche
    final contacts = UserData.users.where((user) {
      String nomComplet =
          '${user['prenom']} ${user['nom']}'.toLowerCase();
      String email = user['email'].toString().toLowerCase();
      String recherche = searchText.toLowerCase();

      return nomComplet.contains(recherche) ||
          email.contains(recherche);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Répertoire des contacts'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un contact...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Nombre de contacts : ${contacts.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: contacts.isEmpty
                ? const Center(
                    child: Text('Aucun contact trouvé'),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      String prenom =
                          contact['prenom'].toString();
                      String nom =
                          contact['nom'].toString();
                      String email =
                          contact['email'].toString();

                      String initiales =
                          '${prenom[0]}${nom[0]}'.toUpperCase();

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(
                              initiales,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            '$prenom $nom',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(email),
                          trailing: const Icon(
                            Icons.contact_mail,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}