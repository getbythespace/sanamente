// lib/models/encuesta.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Encuesta {
  final String id;
  final String usuarioId;
  final DateTime fecha;
  final int bienestar;
  final int? motivacion; // Opcional
  final String? comentario; // Opcional

  Encuesta({
    required this.id,
    required this.usuarioId,
    required this.fecha,
    required this.bienestar,
    this.motivacion,
    this.comentario,
  });

  factory Encuesta.fromMap(Map<String, dynamic> map) {
    return Encuesta(
      id: map['id'],
      usuarioId: map['usuarioId'],
      fecha: (map['fecha'] as Timestamp).toDate(),
      bienestar: map['bienestar'],
      motivacion: map['motivacion'],
      comentario: map['comentario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'fecha': fecha, // Firestore puede manejar DateTime directamente
      'bienestar': bienestar,
      'motivacion': motivacion,
      'comentario': comentario,
    };
  }
}
