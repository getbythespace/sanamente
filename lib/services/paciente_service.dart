// lib/services/paciente_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class PacienteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Usuario>> getPoolPacientes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: 'paciente')
          .where('psicologoAsignado', isEqualTo: null)
          .get();

      return snapshot.docs.map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> vincularPsicologo(String pacienteUid, String psicologoUid) async {
    try {
      await _firestore.collection('users').doc(pacienteUid).update({
        'psicologoAsignado': psicologoUid,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Usuario>> getMisPacientes(String psicologoUid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: 'paciente')
          .where('psicologoAsignado', isEqualTo: psicologoUid)
          .get();

      return snapshot.docs.map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
