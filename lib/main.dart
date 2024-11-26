import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/registro_screen.dart'; // Importa la pantalla de registro

void main() async {
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
      title: 'Sanamente App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  RegistroScreen(), // Cambiar la pantalla inicial
    );
  }
}
