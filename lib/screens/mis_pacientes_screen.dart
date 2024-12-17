import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/paciente_service.dart';
import '../services/auth_service.dart';
import '../models/rol.dart';

class MisPacientesScreen extends StatefulWidget {
  const MisPacientesScreen({Key? key}) : super(key: key);

  @override
  _MisPacientesScreenState createState() => _MisPacientesScreenState();
}

class _MisPacientesScreenState extends State<MisPacientesScreen> {
  List<Usuario> _pacientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPacientes();
  }

  void _loadPacientes() async {
    final pacienteService = Provider.of<PacienteService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // Obtener el psicólogo autenticado
      final Usuario? psicologo = await authService.currentUser;
      if (psicologo == null || psicologo.rol != Rol.psicologo) {
        throw Exception('El usuario no está autenticado o no es psicólogo.');
      }

      // Obtener pacientes asignados
      List<Usuario> pacientes =
          await pacienteService.getPacientesAsignados(psicologo.uid);

      setState(() {
        _pacientes = pacientes;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar pacientes: $e')),
      );
      setState(() {
        _pacientes = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pacientes.isEmpty) {
      return const Center(child: Text('No tienes pacientes asignados.'));
    }

    return ListView.builder(
      itemCount: _pacientes.length,
      itemBuilder: (context, index) {
        final paciente = _pacientes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.person, size: 40),
            title: Text('${paciente.nombres} ${paciente.apellidos}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Correo: ${paciente.email}'),
                Text('Carrera: ${paciente.carrera}'),
                Text('Edad: ${paciente.edad}'),
                Text('Campus: ${paciente.campus ?? 'No especificado'}'),
              ],
            ),
            isThreeLine: true,
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
  }
}
