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
      rethrow; // Usar 'rethrow' para preservar la pila
    }
  }

  @override
  Future<Usuario?> obtenerUsuarioPorUid(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        return Usuario.fromMap(docSnapshot.data()!);
      }

      debugPrint('No se encontró el usuario con UID: $uid');
      return null;
    } catch (e) {
      debugPrint('Error al obtener usuario por UID: $e');
      rethrow; // Usar 'rethrow' para preservar la pila
    }
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    try {
      // Iniciar una transacción para asegurar la unicidad del RUT
      await _firestore.runTransaction((transaction) async {
        // Referencia al documento del RUT
        DocumentReference rutRef = _firestore.collection('ruts').doc(usuario.rut);

        // Verificar si el RUT ya existe
        final rutDoc = await transaction.get(rutRef);
        if (rutDoc.exists) {
          throw Exception('El RUT ya está registrado.');
        }

        // Crear usuario en Firestore
        DocumentReference userRef = _firestore.collection('users').doc(usuario.uid);
        transaction.set(userRef, usuario.toMap());

        // Registrar el RUT
        transaction.set(rutRef, {'uid': usuario.uid});
      });

      debugPrint('Usuario guardado correctamente: ${usuario.uid}');
    } catch (e) {
      debugPrint('Error al guardar usuario: $e');
      rethrow; // Usar 'rethrow' para preservar la pila
    }
  }

  @override
  Future<bool> isRutUnique(String rut) async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('rut', isEqualTo: rut)
        .get();

    return querySnapshot.docs.isEmpty;
  }
}
