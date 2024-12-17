import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'firebase_options.dart';

import 'models/usuario.dart';
import 'models/encuesta.dart';
import 'models/rol.dart';

import 'repositories/identificacion_repository.dart';
import 'repositories/mock_identificacion_repository.dart';
import 'repositories/real_identificacion_repository.dart';

import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/encuesta_service.dart';
import 'services/paciente_service.dart';
import 'services/admin_service.dart';

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
import 'screens/nuevo_animo_screen.dart';

// Firebase
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    const bool usarMock = false;

    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MultiProvider(
          providers: [
            // Proveedor de IdentificacionRepository
            Provider<IdentificacionRepository>(
              create: (_) => usarMock
                  ? MockIdentificacionRepository()
                  : RealIdentificacionRepository(
                      FirebaseFirestore.instance,
                    ),
            ),

            // Proveedor de AuthService, que depende de IdentificacionRepository
            Provider<AuthService>(
              create: (context) => AuthService(
                context.read<IdentificacionRepository>(),
              ),
            ),

            //  servicios
            Provider<NotificationService>(
              create: (_) => NotificationService(),
            ),
            Provider<EncuestaService>(
              create: (_) => EncuestaService(),
            ),
            Provider<PacienteService>(
              create: (_) => PacienteService(),
            ),

            // AdminService que depende de AuthService y IdentificacionRepository
            ProxyProvider2<AuthService, IdentificacionRepository, AdminService>(
              update:
                  (context, authService, identificacionRepository, previous) =>
                      AdminService(
                authService: authService,
                identificacionRepository: identificacionRepository,
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sanamente',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/crear_usuario': (context) {
          final Rol rol = ModalRoute.of(context)!.settings.arguments as Rol;
          return CrearUsuarioScreen(rol: rol);
        },
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
        '/admin': (context) => const AdminScreen(),
        '/psicologo': (context) => const PsicologoScreen(),
        '/paciente': (context) => const PacienteScreen(),
        '/nuevo_animo': (context) => const NuevoAnimoScreen(),
      },
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({required this.error, super.key});

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
