// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'login_screen.dart';
import 'paciente_screen.dart';
import 'psicologo_screen.dart';
import 'admin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return StreamBuilder<Usuario?>(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Usuario? usuario = snapshot.data;
          if (usuario == null) {
            return const LoginScreen(); // Muestra Login si no hay usuario autenticado
          } else {
            // Puedes usar `usuario.rut` aquí si es necesario
            switch (usuario.tipoUsuario.toLowerCase()) {
              case 'psicologo':
                return const PsicologoScreen();
              case 'paciente':
                return const PacienteScreen();
              case 'admin':
                return const AdminScreen();
              default:
                return const Scaffold(
                  body: Center(
                    child: Text('Rol de usuario desconocido.'),
                  ),
                );
            }
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
