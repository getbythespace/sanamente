// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import '../repositories/identificacion_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final IdentificacionRepository _identificacionRepository;

  AuthService(this._identificacionRepository);

  /// Stream para el estado del usuario
  Stream<Usuario?> get user {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) return null;
      // Obtén los datos adicionales del usuario desde Firestore
      final usuario = await _identificacionRepository.obtenerUsuarioPorUid(firebaseUser.uid);
      return usuario;
    });
  }

  /// Método para registrar con correo y contraseña
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
    required String carrera, // Nuevo parámetro
    required int edad, // Nuevo parámetro
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Crear objeto Usuario con los nuevos campos
        Usuario nuevoUsuario = Usuario(
          uid: user.uid,
          rut: rut,
          nombres: nombres,
          apellidos: apellidos,
          email: email,
          rol: rol,
          celular: celular,
          psicologoAsignado: psicologoAsignado,
          campus: campus,
          carrera: carrera, // Asignar carrera
          edad: edad, // Asignar edad
        );

        // Guardar usuario en la base de datos
        await _identificacionRepository.saveUsuario(nuevoUsuario);

        return nuevoUsuario;
      } else {
        return null;
      }
    } catch (e) {
      // Puedes agregar un manejo de errores más específico aquí si lo deseas
      rethrow;
    }
  }

  /// Método para iniciar sesión con correo y contraseña
  Future<Usuario?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        Usuario? usuario = await _identificacionRepository.obtenerUsuarioPorUid(user.uid);
        return usuario;
      } else {
        return null;
      }
    } catch (e) {
      // Puedes agregar un manejo de errores más específico aquí si lo deseas
      rethrow;
    }
  }

  /// Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
