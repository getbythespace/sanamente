// lib/screens/mis_pacientes_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/paciente_service.dart';
import '../services/auth_service.dart';

class MisPacientesScreen extends StatelessWidget {
  const MisPacientesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pacienteService = Provider.of<PacienteService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<Usuario?>(
      future: authService.currentUser,
      builder: (context, snapshotUsuario) {
        if (snapshotUsuario.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshotUsuario.hasError || !snapshotUsuario.hasData || snapshotUsuario.data == null) {
          return const Center(child: Text('No se pudo obtener el psicólogo.'));
        }

        final Usuario psicologo = snapshotUsuario.data!;

        return FutureBuilder<List<Usuario>>(
          future: pacienteService.getMisPacientes(psicologo.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar pacientes.'));
            }

            final pacientes = snapshot.data ?? [];

            if (pacientes.isEmpty) {
              return const Center(child: Text('No tienes pacientes vinculados.'));
            }

            return ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {
                final paciente = pacientes[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text('${paciente.nombres} ${paciente.apellidos}'),
                    subtitle: Text('Carrera: ${paciente.carrera}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/perfil_paciente',
                          arguments: paciente,
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
