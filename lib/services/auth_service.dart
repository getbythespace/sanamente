// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../repositories/identificacion_repository.dart';
import 'package:flutter/foundation.dart';


class AuthService {
  final IdentificacionRepository _repository;
  final FirebaseAuth _firebaseAuth;

  AuthService(this._repository) : _firebaseAuth = FirebaseAuth.instance;

  // Stream que emite el usuario actual
  Stream<Usuario?> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser != null) {
        final usuario = await _repository.obtenerUsuarioPorRut(firebaseUser.uid);
        return usuario;
      }
      return null;
    });
  }

 Future<Usuario?> signInWithRutAndPassword({
  required String rut,
  required String password,
}) async {
  try {
    // Buscar usuario por RUT en el repositorio
    final usuario = await _repository.obtenerUsuarioPorRut(rut);

    if (usuario == null) {
      debugPrint('No se encontró el usuario con RUT: $rut');
      return null;
    }

    // Validar credenciales (Firebase Authentication)
    UserCredential credenciales = await _firebaseAuth.signInWithEmailAndPassword(
      email: usuario.email, // Usamos el email del usuario encontrado
      password: password,
    );

    debugPrint('Inicio de sesión exitoso para UID: ${credenciales.user!.uid}');
    return usuario;
  } on FirebaseAuthException catch (e) {
    debugPrint('Error en AuthService (signInWithRutAndPassword): ${e.code} - ${e.message}');
    return null;
  } catch (e) {
    debugPrint('Error desconocido en AuthService (signInWithRutAndPassword): $e');
    return null;
  }
}


  // Método para registrar un nuevo usuario
  Future<Usuario?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String rut,
    required String nombres,
    required String apellidos,
    required String tipoUsuario,
    String? celular,
    String? psicologoAsignado,
    String? campus,
  }) async {
    try {
      UserCredential credenciales = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Usuario usuario = Usuario(
        uid: credenciales.user!.uid,
        nombres: nombres,
        apellidos: apellidos,
        email: email,
        tipoUsuario: tipoUsuario,
        celular: celular,
        psicologoAsignado: psicologoAsignado,
        campus: campus,
        rut: rut,
      );

      // Guardar usuario en el repositorio
      await _repository.saveUsuario(usuario);

      return usuario;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error en AuthService (registro): ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Error desconocido en AuthService (registro): $e');
      return null;
    }
    
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  
}
