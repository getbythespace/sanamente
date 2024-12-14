// lib/screens/list_usuarios_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';
import 'editar_usuario_screen.dart';

class ListUsuariosScreen extends StatelessWidget {
  final Rol rol;

  const ListUsuariosScreen({Key? key, required this.rol}) : super(key: key);

  void _editarUsuario(BuildContext context, Usuario usuario) {
    Navigator.pushNamed(
      context,
      '/editar_usuario',
      arguments: usuario,
    );
  }

  void _eliminarUsuario(BuildContext context, Usuario usuario) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: Text('¿Estás seguro de eliminar a ${usuario.nombres} ${usuario.apellidos}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final adminService = Provider.of<AdminService>(context, listen: false);
      await adminService.eliminarUsuario(usuario.uid);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario ${usuario.nombres} eliminado exitosamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminService>(context, listen: false);

    return FutureBuilder<List<Usuario>>(
      future: adminService.getUsuariosByRol(rol),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar usuarios.'));
        }

        final usuarios = snapshot.data ?? [];

        if (usuarios.isEmpty) {
          return const Center(child: Text('No hay usuarios registrados.'));
        }

        return ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (context, index) {
            final usuario = usuarios[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('${usuario.nombres} ${usuario.apellidos}'),
                subtitle: Text('Correo: ${usuario.email}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editarUsuario(context, usuario),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarUsuario(context, usuario),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
