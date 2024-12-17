import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/encuesta.dart';

class EncuestaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Encuesta>> getLatestEncuestas(String usuarioId, {int limit = 5}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('encuestas')
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fecha', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Encuesta>> getEncuestasByDateRange({
  required String usuarioId,
  DateTime? start,
  DateTime? end,
  String? psicologoId,
}) async {
  try {
    Query query = _firestore.collection('encuestas');

    // Filtrar por usuarioId o por psicólogo vinculado
    if (psicologoId != null) {
      query = query.where('psicologoId', isEqualTo: psicologoId);
    } else {
      query = query.where('usuarioId', isEqualTo: usuarioId);
    }

    // Filtrar por rango de fechas
    if (start != null && end != null) {
      query = query
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(end));
    }

    QuerySnapshot snapshot = await query.orderBy('fecha', descending: false).get();

    return snapshot.docs
        .map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    rethrow;
  }
}


  Future<List<Encuesta>> getEncuestasByUsuario(String usuarioId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('encuestas')
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Método para agregar una nueva encuesta
  Future<void> addEncuesta(Encuesta encuesta) async {
    try {
      await _firestore.collection('encuestas').add({
        ...encuesta.toMap(),
        'fecha': encuesta.fecha ?? Timestamp.now(), // Asegura una fecha válida
      });
    } catch (e) {
      rethrow;
    }
  }
}
