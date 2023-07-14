import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tome_notas/telas/login.dart';
import 'package:tome_notas/telas/notas.dart';
import 'package:tome_notas/telas/cadastro.dart';
import 'package:tome_notas/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      title: 'login',
      initialRoute: '/login',
      routes: {
        '/login': (context) => MyHome(),
        //'/cadastro': (context) => Cadastro(),
        '/notas': (context) => Notas(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
