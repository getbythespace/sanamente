import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'screens/registro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'repositories/identificacion_repository.dart';
import 'repositories/mock_identificacion_repository.dart';
import 'repositories/real_identificacion_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import necesario

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Mock o Real IdentificacionRepository
    const bool usarMock = false; // Cambia a true para usar MockIdentificacionRepository

    runApp(
      DevicePreview(
        enabled: false, // Cambia a true para desarrollo
        builder: (context) => MultiProvider(
          providers: [
            Provider<IdentificacionRepository>(
              create: (_) => usarMock
                  ? MockIdentificacionRepository()
                  : RealIdentificacionRepository(FirebaseFirestore.instance), // Pasa FirebaseFirestore.instance
            ),
            Provider<AuthService>(
              create: (context) => AuthService(
                context.read<IdentificacionRepository>(),
              ),
            ),
            
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
        '/registro': (context) => const RegistroScreen(), 
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
