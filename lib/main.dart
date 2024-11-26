import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'screens/registro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      DevicePreview(
        enabled: true, // Cambia a false para producción
        builder: (context) => const MyApp(), // Sin const
      ),
    );
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor con key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanamente App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/registro', // Ruta inicial
      routes: {
        '/registro': (context) => RegistroScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
      builder: DevicePreview.appBuilder, // Builder para Device Preview
      locale: DevicePreview.locale(context),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({required this.error, super.key}); // Constructor con key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error al inicializar Firebase: $error'),
        ),
      ),
    );
  }
}
