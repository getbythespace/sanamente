import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import 'identificacion_repository.dart';

class RealIdentificacionRepository implements IdentificacionRepository {
  final FirebaseFirestore _firestore;

  /// Constructor que recibe la instancia de [FirebaseFirestore].
  RealIdentificacionRepository(this._firestore);

  @override
  Future<Usuario?> obtenerUsuarioPorRut(String rut) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('rut', isEqualTo: rut)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return Usuario.fromMap(querySnapshot.docs.first.data());
      }

      debugPrint('No se encontró el usuario con RUT: $rut');
      return null;
    } catch (e) {
      debugPrint('Error al obtener usuario por RUT: $e');
      rethrow;
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
      rethrow;
    }
  }

  @override
  Future<void> saveUsuario(Usuario usuario) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(usuario.uid);

        // Intentar obtener el documento
        final snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          // Actualizar los datos del usuario
          transaction.update(userRef, usuario.toMap());
        } else {
          // Crear un nuevo documento si no existe
          transaction.set(userRef, usuario.toMap());
        }
      });

      debugPrint('Usuario guardado correctamente: ${usuario.uid}');
    } catch (e, stackTrace) {
      debugPrint('Error al guardar usuario en Firestore: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow; // error para manejo en AuthService
    }
  }

  @override
  Future<bool> isRutUnique(String rut) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('rut', isEqualTo: rut)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      debugPrint('Error al verificar unicidad del RUT: $e');
      rethrow;
    }
  }

  @override
  Future<List<Usuario>> obtenerUsuariosPorRol(Rol rol) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: rol.name)
          .get();
      return querySnapshot.docs
          .map((doc) => Usuario.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener usuarios por rol: $e');
      rethrow;
    }
  }

  @override
  Future<List<Usuario>> obtenerTodosLosUsuarios() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => Usuario.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener todos los usuarios: $e');
      rethrow;
    }
  }

  @override
  Future<void> eliminarUsuario(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      debugPrint('Usuario eliminado correctamente: $uid');
    } catch (e) {
      debugPrint('Error al eliminar usuario: $e');
      rethrow;
    }
  }
}
