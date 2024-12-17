import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';

class ListUsuariosScreen extends StatefulWidget {
  final Rol rol;
  const ListUsuariosScreen({required this.rol, super.key});

  @override
  State<ListUsuariosScreen> createState() => _ListUsuariosScreenState();
}

class _ListUsuariosScreenState extends State<ListUsuariosScreen> {
  @override
  Widget build(BuildContext context) {
    final adminService = Provider.of<AdminService>(context, listen: false);

    return FutureBuilder<List<Usuario>>(
      future: adminService.getUsuariosByRol(widget.rol),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay ${widget.rol.name}s disponibles.'));
        } else {
          final usuarios = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {}); // Refresca la lista
            },
            child: ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y Apellido
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${usuario.nombres} ${usuario.apellidos}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                // Botón de Editar
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/editar_usuario',
                                      arguments: usuario,
                                    );
                                  },
                                  tooltip: 'Editar Usuario',
                                ),
                                // Botón de Eliminar
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    bool confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar Eliminación'),
                                        content: const Text('¿Estás seguro de eliminar este usuario?'),
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

                                    if (confirm) {
                                      try {
                                        await adminService.eliminarUsuario(usuario.uid);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Usuario eliminado exitosamente.')),
                                        );
                                        setState(() {}); // Refresca la lista tras eliminar
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error al eliminar usuario: $e')),
                                        );
                                      }
                                    }
                                  },
                                  tooltip: 'Eliminar Usuario',
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Detalles del Usuario
                        Text('Correo Electrónico: ${usuario.email}'),
                        Text('RUT: ${usuario.rut}'),
                        Text('Edad: ${usuario.edad}'),
                        if (usuario.celular != null && usuario.celular!.isNotEmpty)
                          Text('Celular: ${usuario.celular}'),
                        Text('Campus: ${usuario.campus}'),
                        if (usuario.carrera.isNotEmpty)
                          Text('Carrera: ${usuario.carrera}'),
                        if (usuario.psicologoAsignado != null && usuario.psicologoAsignado!.isNotEmpty)
                          Text('Psicólogo Asignado: ${usuario.psicologoAsignado}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
