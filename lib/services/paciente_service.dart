import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class PacienteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener pacientes sin psicólogo asignado
  Future<List<Usuario>> getPoolPacientes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: 'paciente')
          .where('psicologoAsignado', isEqualTo: null)
          .get();

      return snapshot.docs
          .map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Vincular psicólogo a paciente
  Future<void> vincularPsicologo(String pacienteUid, String psicologoUid) async {
    try {
      await _firestore.collection('users').doc(pacienteUid).update({
        'psicologoAsignado': psicologoUid,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Obtener pacientes asignados a un psicólogo específico
  Future<List<Usuario>> getPacientesAsignados(String psicologoId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('psicologoAsignado', isEqualTo: psicologoId)
          .get();

      return querySnapshot.docs
          .map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener pacientes asignados: $e');
    }
  }
}
