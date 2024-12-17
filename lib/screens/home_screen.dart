import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/rol.dart';
import 'login_screen.dart';
import 'paciente_screen.dart';
import 'psicologo_screen.dart';
import 'admin_screen.dart';
import '../models/usuario.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<Usuario?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final Usuario? usuario = snapshot.data;
          if (usuario == null) {
            // Usuario no está autenticado
            return const LoginScreen();
          }

          // Redirigir según el rol
          switch (usuario.rol) {
            case Rol.paciente:
              return const PacienteScreen();
            case Rol.psicologo:
              return const PsicologoScreen();
            case Rol.admin:
              return const AdminScreen();
            default:
              return const Scaffold(
                body: Center(child: Text('Rol desconocido')),
              );
          }
        }

        // Estado de conexión
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
