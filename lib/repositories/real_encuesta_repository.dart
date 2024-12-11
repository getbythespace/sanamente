// lib/repositories/real_encuesta_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/encuesta.dart';
import 'encuesta_repository.dart';

class RealEncuestaRepository implements EncuestaRepository {
  final FirebaseFirestore _firestore;

  RealEncuestaRepository(this._firestore);

  @override
  Future<void> saveEncuesta(Encuesta encuesta) async {
    try {
      await _firestore.collection('encuestas').doc(encuesta.id).set(encuesta.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Encuesta>> getEncuestasByUsuario(String usuarioId) async {
    try {
      final querySnapshot = await _firestore
          .collection('encuestas')
          .where('usuarioId', isEqualTo: usuarioId)
          .get();

      return querySnapshot.docs.map((doc) => Encuesta.fromMap(doc.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateEncuesta(Encuesta encuesta) async {
    try {
      await _firestore.collection('encuestas').doc(encuesta.id).update(encuesta.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEncuesta(String encuestaId) async {
    try {
      await _firestore.collection('encuestas').doc(encuestaId).delete();
    } catch (e) {
      rethrow;
    }
  }
}

