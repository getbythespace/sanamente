import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../repositories/real_identificacion_repository.dart';

class CrudUsuariosScreen extends StatelessWidget {
  const CrudUsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final identificacionRepository =
        Provider.of<RealIdentificacionRepository>(context, listen: false);

    return FutureBuilder<List<Usuario>>(
      future: identificacionRepository.obtenerTodosLosUsuarios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final usuarios = snapshot.data ?? [];
        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (context, index) {
            final usuario = usuarios[index];
            return ListTile(
              title: Text('${usuario.nombres} ${usuario.apellidos}'),
              subtitle: Text(usuario.email),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Editar') {
                    Navigator.pushNamed(context, '/editar_usuario',
                        arguments: usuario);
                  } else if (value == 'Eliminar') {
                    _eliminarUsuario(context, usuario.uid);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Editar', child: Text('Editar')),
                  const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _eliminarUsuario(BuildContext context, String uid) {
    final identificacionRepository =
        Provider.of<RealIdentificacionRepository>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await identificacionRepository.eliminarUsuario(uid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario eliminado correctamente')),
              );
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
