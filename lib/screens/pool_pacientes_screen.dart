import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/paciente_service.dart';
import '../services/auth_service.dart';

class PoolPacientesScreen extends StatelessWidget {
  const PoolPacientesScreen({Key? key}) : super(key: key);

  void _vincularPaciente(BuildContext context, Usuario paciente) async {
    final psicologo = await Provider.of<AuthService>(context, listen: false).currentUser;
    if (psicologo == null) return;

    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vincular Paciente'),
        content: Text(
            '¿Estás seguro de vincular a ${paciente.nombres} ${paciente.apellidos}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vincular'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final pacienteService =
          Provider.of<PacienteService>(context, listen: false);
      try {
        await pacienteService.vincularPsicologo(paciente.uid, psicologo.uid);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Paciente ${paciente.nombres} vinculado exitosamente.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al vincular paciente: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pacienteService =
        Provider.of<PacienteService>(context, listen: false);

    return FutureBuilder<List<Usuario>>(
      future: pacienteService.getPoolPacientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar pacientes.'));
        }

        final pacientes = snapshot.data ?? [];

        if (pacientes.isEmpty) {
          return const Center(child: Text('No hay pacientes para vincular.'));
        }

        return ListView.builder(
          itemCount: pacientes.length,
          itemBuilder: (context, index) {
            final paciente = pacientes[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person, size: 40),
                title: Text('${paciente.nombres} ${paciente.apellidos}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Carrera: ${paciente.carrera}'),
                    Text('Edad: ${paciente.edad}'),
                    if (paciente.celular != null)
                      Text('Celular: ${paciente.celular}'),
                    Text('Campus: ${paciente.campus}'),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _vincularPaciente(context, paciente),
                  tooltip: 'Vincular Paciente',
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/perfil_paciente',
                    arguments: paciente, 
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
