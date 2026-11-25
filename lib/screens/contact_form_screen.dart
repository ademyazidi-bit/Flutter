import 'package:flutter/material.dart';

import '../data/contact_data.dart';
import '../data/user_data.dart';
import '../models/contact.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _telephoneController = TextEditingController();

  bool _controllersInitialises = false;
  Contact? _contact;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controllersInitialises) {
      return;
    }

    _contact = ModalRoute.of(context)?.settings.arguments as Contact?;
    if (_contact != null) {
      _prenomController.text = _contact!.prenom;
      _nomController.text = _contact!.nom;
      _telephoneController.text = _contact!.telephone;
    }
    _controllersInitialises = true;
  }

  void _enregistrer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = UserData.emailConnecte;
    if (email == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    final prenom = _prenomController.text.trim();
    final nom = _nomController.text.trim();
    final telephone = _telephoneController.text.trim();

    if (_contact == null) {
      ContactData.ajouterContact(email, nom, prenom, telephone);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Contact ajouté')));
    } else {
      ContactData.modifierContact(email, _contact!.id, nom, prenom, telephone);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Contact modifié')));
    }

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _prenomController.dispose();
    _nomController.dispose();
    _telephoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estModification = _contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          estModification ? 'Modifier le contact' : 'Ajouter un contact',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final telephone = value?.trim() ?? '';
                    if (telephone.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }
                    if (!RegExp(r'^[0-9+]+$').hasMatch(telephone)) {
                      return 'Veuillez entrer un numéro valide';
                    }

                    final email = UserData.emailConnecte;
                    if (email != null &&
                        ContactData.telephoneExiste(
                          email,
                          telephone,
                          ignorerId: _contact?.id,
                        )) {
                      return 'Ce numéro de téléphone existe déjà';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _enregistrer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        estModification ? 'Enregistrer' : 'Ajouter',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
