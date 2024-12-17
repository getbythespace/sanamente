import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../models/rol.dart';
import 'auth_service.dart';
import '../repositories/identificacion_repository.dart';
import 'package:flutter/foundation.dart';


class AdminService {
  final IdentificacionRepository _identificacionRepository;
  final AuthService _authService;

  AdminService({
    required IdentificacionRepository identificacionRepository,
    required AuthService authService,
  })  : _identificacionRepository = identificacionRepository,
        _authService = authService;

  Future<List<Usuario>> getUsuariosByRol(Rol rol) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('rol', isEqualTo: rol.name)
          .get();
      return snapshot.docs
          .map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error al obtener usuarios por rol: $e');
      rethrow;
    }
  }

  Future<void> crearUsuario(Usuario usuario, String password) async {
    try {
      
      await _authService.registerWithEmailAndPassword(
        email: usuario.email,
        password: password,
        rut: usuario.rut,
        nombres: usuario.nombres,
        apellidos: usuario.apellidos,
        rol: usuario.rol,
        celular: usuario.celular ?? '',
        psicologoAsignado: usuario.psicologoAsignado ?? '',
        campus: usuario.campus ?? '',
        carrera: usuario.carrera,
        edad: usuario.edad,
      );
    } catch (e) {
      debugPrint('Error al crear usuario: $e');
      rethrow;
    }
  }

  Future<void> editarUsuario(Usuario usuario) async {
    try {
      await _identificacionRepository.saveUsuario(usuario);
    } catch (e) {
      debugPrint('Error al editar usuario: $e');
      rethrow;
    }
  }

  Future<void> eliminarUsuario(String uid) async {
    try {
      final currentUser = _authService.currentFirebaseUser;
      if (currentUser != null && currentUser.uid == uid) {
        throw Exception('No puedes eliminar tu propio usuario mientras estás autenticado.');
      }
      await _identificacionRepository.eliminarUsuario(uid);
    } catch (e) {
      debugPrint('Error al eliminar usuario: $e');
      rethrow;
    }
  }
}
