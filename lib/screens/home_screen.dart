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
    AuthService authService = Provider.of<AuthService>(context);
    return StreamBuilder<Usuario?>(
      stream: authService.user.map((user) async {
        if (user != null) {
          // Obtener datos del usuario desde Firestore
          // Asegúrate de manejar esto de manera eficiente en tu AuthService
          // o utiliza un método aquí para obtener los datos.
          // Por simplicidad, asumimos que el AuthService ya los tiene.
          // Si no, ajusta este código para obtenerlos.
          // Por ahora, devolvemos una instancia vacía.
          // Implementa según tu estructura.
          return null; // Reemplaza con la instancia real
        } else {
          return null;
        }
      }).asyncMap((usuario) async => usuario),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Usuario? usuario = snapshot.data;
          if (usuario == null) {
            return const LoginScreen();
          } else {
            // Navegar según el rol
            if (usuario.rol == 'psicologo') {
              return const PsicologoScreen();
            } else if (usuario.rol == 'paciente') {
              return const PacienteScreen();
            } else if (usuario.rol == 'admin') {
              return const AdminScreen();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Rol de usuario desconocido.'),
                ),
              );
            }
          }
        } else {
          return const Scaffold(
          body: Center(child: Text('Rol de usuario desconocido.')),
          );
        }
      },
    );
  }
}
