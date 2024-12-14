// lib/screens/detalles_encuesta_screen.dart

import 'package:flutter/material.dart';
import '../models/encuesta.dart';

class DetallesEncuestaScreen extends StatelessWidget {
  final Encuesta encuesta;

  const DetallesEncuestaScreen({Key? key, required this.encuesta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de Encuesta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${encuesta.fecha.toLocal().toString().split(' ')[0]}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Bienestar: ${encuesta.bienestar}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (encuesta.motivacion != null)
              Text('Motivación: ${encuesta.motivacion}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (encuesta.comentario != null)
              Text('Comentario: ${encuesta.comentario}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
