// lib/widgets/latest_entries.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/encuesta.dart';
import '../services/encuesta_service.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';

class LatestEntries extends StatelessWidget {
  const LatestEntries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final encuestaService = Provider.of<EncuestaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder<Usuario?>(
      future: authService.currentUser,
      builder: (context, snapshotUsuario) {
        if (snapshotUsuario.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshotUsuario.hasError || !snapshotUsuario.hasData || snapshotUsuario.data == null) {
          return const Center(child: Text('No se pudo obtener el usuario.'));
        }

        final Usuario usuario = snapshotUsuario.data!;

        return FutureBuilder<List<Encuesta>>(
          future: encuestaService.getLatestEncuestas(usuario.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar registros.'));
            }

            final encuestas = snapshot.data ?? [];

            if (encuestas.isEmpty) {
              return const Center(child: Text('No hay registros recientes.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Últimos Registros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: encuestas.length,
                  itemBuilder: (context, index) {
                    final encuesta = encuestas[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.sentiment_satisfied, color: Colors.green),
                        title: Text('Bienestar: ${encuesta.bienestar}'),
                        subtitle: Text('Fecha: ${encuesta.fecha.toLocal().toString().split(' ')[0]}'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detalles_encuesta',
                            arguments: encuesta,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
