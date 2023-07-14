import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => MyHomeState();
}

class MyHomeState extends State<MyHome> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        print('User is signed in!');
        Navigator.of(context).pushReplacementNamed('/menu');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('App de Contatos'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 0.0),
        child: Column(
          children: [
            SizedBox(height: 100.0),
            Image.asset('img/ifpi.png', width: 150.0),
            SizedBox(height: 70.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Senha",
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              child: Text('Entrar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                String email = _emailController.text.trim();
                String senha = _senhaController.text.trim();
                _login(email, senha);
              },
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              child: Text('Cadastre-se agora'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(String email, String senha) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Ocorreu um erro ao fazer o login.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
