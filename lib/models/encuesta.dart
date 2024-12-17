import 'package:cloud_firestore/cloud_firestore.dart';

class Encuesta {
  final String id;
  final String usuarioId;
  final String psicologoId;
  final DateTime fecha;
  final int bienestar;
  final int? motivacion; 
  final String? comentario;

  Encuesta({
    required this.id,
    required this.usuarioId,
    required this.psicologoId,
    required this.fecha,
    required this.bienestar,
    this.motivacion,
    this.comentario,
  });

  factory Encuesta.fromMap(Map<String, dynamic> data) {
    return Encuesta(
      id: data['__name__'] ?? '',
      usuarioId: data['usuarioId'] ?? '',
      psicologoId: data['psicologoId'] ?? '',
      fecha: (data['fecha'] as Timestamp).toDate(),
      bienestar: data['bienestar'] ?? 0,
      motivacion: data['motivacion'],
      comentario: data['comentario'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'psicologoId': psicologoId,
      'fecha': Timestamp.fromDate(fecha),
      'bienestar': bienestar,
      'motivacion': motivacion,
      'comentario': comentario,
    };
  }
}
