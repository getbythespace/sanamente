// lib/screens/paciente_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../widgets/mood_chart.dart';
import '../widgets/notification_schedule.dart';
import '../widgets/latest_entries.dart';

class PacienteScreen extends StatelessWidget {
  const PacienteScreen({super.key});

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
            return const Scaffold(
              body: Center(child: Text('No autenticado')),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Sanamente'),
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/perfil');
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 8),
                      Text(usuario.nombres),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gráfico de ánimo
                  MoodChart(
                    data: [], // Reemplaza con tus datos reales
                    onViewMore: () {
                      Navigator.pushNamed(context, '/grafico_detallado');
                    },
                  ),
                  const SizedBox(height: 20),
                  // Horario de notificaciones
                  const NotificationSchedule(),
                  const SizedBox(height: 20),
                  // Últimos registros
                  const LatestEntries(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Acción para registrar nuevo ánimo
                Navigator.pushNamed(context, '/nuevo_amo'); // Asegúrate de tener esta ruta
              },
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    authService.signOut();
                  },
                  child: const Text('Cerrar Sesión'),
                ),
              ),
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
