// lib/main.dart

import 'models/usuario.dart';
import 'models/encuesta.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';

// Importación de Screens
import 'screens/registro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/grafico_detallado_screen.dart';
import 'screens/detalles_encuesta_screen.dart';
import 'screens/paciente_screen.dart';
import 'screens/psicologo_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/crear_usuario_screen.dart';
import 'screens/editar_usuario_screen.dart';
import 'screens/perfil_paciente_screen.dart';

// Importación de Services
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/encuesta_service.dart';
import 'services/paciente_service.dart';
import 'services/admin_service.dart';

// Importación de Repositories
import 'repositories/identificacion_repository.dart';
import 'repositories/mock_identificacion_repository.dart';
import 'repositories/real_identificacion_repository.dart';

// Importación de Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Determina si usar el repositorio Mock o Real
    const bool usarMock =
        false; // Cambia a true para usar MockIdentificacionRepository

    runApp(
      DevicePreview(
        enabled: false, // Cambia a true para desarrollo
        builder: (context) => MultiProvider(
          providers: [
            // Proveedor para IdentificacionRepository
            Provider<IdentificacionRepository>(
              create: (_) => usarMock
                  ? MockIdentificacionRepository()
                  : RealIdentificacionRepository(FirebaseFirestore.instance),
            ),
            // Proveedor para AuthService
            Provider<AuthService>(
              create: (context) => AuthService(
                context.read<IdentificacionRepository>(),
              ),
            ),
            // Proveedor para NotificationService
            Provider<NotificationService>(
              create: (_) => NotificationService(),
            ),
            // Proveedor para EncuestaService
            Provider<EncuestaService>(
              create: (_) => EncuestaService(),
            ),
            // Proveedor para PacienteService
            Provider<PacienteService>(
              create: (_) => PacienteService(),
            ),
            // Proveedor para AdminService
            Provider<AdminService>(
              create: (_) => AdminService(),
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
        '/admin': (context) => const AdminScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/home': (context) => const HomeScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/grafico_detallado': (context) => const GraficoDetalladoScreen(),
        '/detalles_encuesta': (context) {
          final Encuesta encuesta =
              ModalRoute.of(context)!.settings.arguments as Encuesta;
          return DetallesEncuestaScreen(encuesta: encuesta);
        },
        '/perfil_paciente': (context) {
          final Usuario paciente =
              ModalRoute.of(context)!.settings.arguments as Usuario;
          return PerfilPacienteScreen(paciente: paciente);
        },
        '/editar_usuario': (context) {
          final Usuario usuario =
              ModalRoute.of(context)!.settings.arguments as Usuario;
          return EditarUsuarioScreen(usuario: usuario);
        },
        // Agrega aquí otras rutas según tus necesidades
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
