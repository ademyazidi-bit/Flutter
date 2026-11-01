import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: LoginPage()));
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  String message = '';

  void login() {
    if (email.text == 'test@test.com' &&
        password.text == '1234') {
      setState(() {
        message = 'Connexion réussie';
      });
    } else {
      setState(() {
        message = 'Email ou mot de passe incorrect';
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
            controller: email,
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(labelText: 'Mot de passe'),
            controller: password,
          ),
          ElevatedButton(
            child: Text('Se connecter'),
            onPressed: login,
          ),
          Text(message),
        ],
      ),
    );
  }
}