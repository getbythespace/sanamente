import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de importar Firebase Firestore
import 'firebase_options.dart';
import 'screens/registro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'repositories/identificacion_repository.dart';
import 'repositories/mock_identificacion_repository.dart';
import 'repositories/real_identificacion_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Decide si usar Mock o Real IdentificacionRepository
    const bool usarMock = true; // Cambia a false para usar RealIdentificacionRepository

    runApp(
      DevicePreview(
        enabled: true, // Cambia a false para producción
        builder: (context) => MultiProvider(
          providers: [
            Provider<IdentificacionRepository>(
              create: (_) => usarMock
                  ? MockIdentificacionRepository()
                  : RealIdentificacionRepository(FirebaseFirestore.instance), // Pasar Firestore aquí
            ),
            Provider<AuthService>(
              create: (context) => AuthService(context.read<IdentificacionRepository>()),
            ),
            // Agrega otros providers aquí si es necesario
          ],
          child: const MyApp(),
        ),
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
      title: 'Sanamente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(), // Widget inicial
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => RegistroScreen(), // No usar const si RegistroScreen tiene lógica interna
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
