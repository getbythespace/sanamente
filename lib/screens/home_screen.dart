import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'login_screen.dart'; // Importar LoginScreen

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

          // Usuario está autenticado, muestra la pantalla de inicio
          return Scaffold(
            appBar: AppBar(
              title: Text('Bienvenido, ${usuario.nombres}'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authService.signOut();
                  },
                ),
              ],
            ),
            body: Center(
              child: Text('Tu rol es: ${usuario.rol.name}'), 
            ),
          );
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
