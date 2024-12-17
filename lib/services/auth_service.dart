// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import '../repositories/identificacion_repository.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IdentificacionRepository _identificacionRepository;

  AuthService(this._identificacionRepository);



  // cambios de autenticación
  Stream<Usuario?> get user {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _identificacionRepository
          .obtenerUsuarioPorUid(firebaseUser.uid);
    });
  }

  
  User? get currentFirebaseUser => _auth.currentUser;

  
  Future<Usuario?> get currentUser async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _identificacionRepository.obtenerUsuarioPorUid(user.uid);
  }

  
  Future<Usuario?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String rut,
    required String nombres,
    required String apellidos,
    required Rol rol,
    String? celular,
    String? psicologoAsignado,
    required String campus,
    required String carrera,
    required int edad,
  }) async {
    try {
      // Verificar  RUT
      bool isUnique = await _identificacionRepository.isRutUnique(rut);
      if (!isUnique) {
        throw Exception('El RUT ya está registrado.');
      }

      // Crear usuario en Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user == null) {
        throw Exception('No se pudo crear el usuario en FirebaseAuth');
      }

      final nuevoUsuario = Usuario(
        uid: user.uid,
        rut: rut,
        nombres: nombres,
        apellidos: apellidos,
        email: email,
        rol: rol,
        celular: celular,
        psicologoAsignado: psicologoAsignado,
        campus: campus,
        carrera: rol == Rol.paciente ? carrera : '',
        edad: edad,
      );

      try {
        
        await _identificacionRepository.saveUsuario(nuevoUsuario);
        return nuevoUsuario;
      } catch (firestoreError) {
        
        debugPrint(
            'Ocurrió un error en Firestore. Se eliminará el usuario de Auth.');
        await user.delete(); //  "correo ya en uso" 
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('El correo ya está registrado.');
      } else if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else {
        throw Exception('Error de FirebaseAuth: ${e.message}');
      }
    } catch (e) {
      debugPrint('Error desconocido en registerWithEmailAndPassword: $e');
      rethrow;
    }
  }

  // Método de inicio de sesión
  Future<Usuario?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        return await _identificacionRepository.obtenerUsuarioPorUid(user.uid);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Método para actualizar perfil
Future<void> updateUserProfile({
  required String email,
  required String celular,
  required String currentPassword,
}) async {
  final user = _auth.currentUser;

  if (user != null) {
    try {
      
      if (email != user.email) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.verifyBeforeUpdateEmail(email);
      }

      // Actualizar datos en Firestore
      final usuario = await _identificacionRepository.obtenerUsuarioPorUid(user.uid);
      if (usuario != null) {
        final updatedUser = Usuario(
          uid: usuario.uid,
          rut: usuario.rut,
          nombres: usuario.nombres,
          apellidos: usuario.apellidos,
          email: email,
          rol: usuario.rol,
          celular: celular,
          psicologoAsignado: usuario.psicologoAsignado,
          campus: usuario.campus,
          carrera: usuario.carrera,
          edad: usuario.edad,
        );

        await _identificacionRepository.saveUsuario(updatedUser);
      }
    } catch (error, stackTrace) {
      debugPrint('Error al actualizar perfil: $error');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  } else {
    throw Exception('Usuario no autenticado.');
  }
}

  // Método para actualizar contraseña
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Actualizar la contraseña
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          throw Exception('La contraseña actual es incorrecta.');
        } else if (e.code == 'weak-password') {
          throw Exception('La nueva contraseña es demasiado débil.');
        } else {
          throw Exception('Error al actualizar la contraseña: ${e.message}');
        }
      }
    } else {
      throw Exception('Usuario no autenticado.');
    }
  }

  // cierre de sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Método para eliminar cuenta
  Future<void> deleteAccount(String currentPassword) async {
    final user = _auth.currentUser;

    if (user != null) {
      try {
        
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        
        await _identificacionRepository.eliminarUsuario(user.uid);

        
        await user.delete();
      } catch (e) {
        debugPrint('Error al eliminar cuenta: $e');
        rethrow;
      }
    } else {
      throw Exception('Usuario no autenticado.');
    }
  }
}
