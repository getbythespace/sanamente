// lib/services/admin_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../models/rol.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Usuario>> getUsuariosByRol(Rol rol) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('rol', isEqualTo: rol.name)
          .get();

      return snapshot.docs.map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> crearUsuario(Usuario usuario, String password) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usuario.email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Guardar usuario en Firestore
        await _firestore.collection('users').doc(user.uid).set(usuario.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editarUsuario(Usuario usuario) async {
    try {
      await _firestore.collection('users').doc(usuario.uid).update(usuario.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> eliminarUsuario(String uid) async {
    try {
      // Eliminar usuario de Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.uid == uid) {
        throw Exception('No puedes eliminar tu propio usuario mientras estás autenticado.');
      }

      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
