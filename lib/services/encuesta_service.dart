// lib/services/encuesta_service.dart

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

      return snapshot.docs.map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Encuesta>> getEncuestasByDateRange(String usuarioId, DateTime start, DateTime end) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('encuestas')
          .where('usuarioId', isEqualTo: usuarioId)
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('fecha', descending: false)
          .get();

      return snapshot.docs.map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>)).toList();
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

      return snapshot.docs.map((doc) => Encuesta.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Otros métodos CRUD para encuestas
}
