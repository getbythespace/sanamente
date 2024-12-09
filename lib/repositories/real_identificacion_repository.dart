// lib/repositories/real_identificacion_repository.dart

import 'package:flutter/foundation.dart'; // Import necesario para debugPrint
import 'package:cloud_firestore/cloud_firestore.dart';
import 'identificacion_repository.dart';
import '../models/usuario.dart';

class RealIdentificacionRepository implements IdentificacionRepository {
  final FirebaseFirestore _firestore;

  RealIdentificacionRepository(this._firestore);

  @override
  Future<Usuario?> obtenerUsuarioPorRut(String rut) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('rut', isEqualTo: rut)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Usuario.fromMap(querySnapshot.docs.first.data());
      }

      debugPrint('No se encontró el usuario con RUT: $rut');
      return null;
    } catch (e) {
      debugPrint('Error al obtener usuario por RUT: $e');
      return null;
    }
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    try {
      await _firestore.collection('users').doc(usuario.uid).set(usuario.toMap());
      debugPrint('Usuario guardado correctamente: ${usuario.uid}');
    } catch (e) {
      debugPrint('Error al guardar usuario: $e');
    }
  }
}