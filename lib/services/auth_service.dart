import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Registro de usuario
  Future<Usuario?> registerWithEmailAndPassword({
    required String nombres,
    required String apellidos,
    required String rut,
    required String email,
    required String password,
    String? celular,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Verificar si el RUT está autorizado como psicólogo
        bool isPsicologo = await _isRutAuthorized(rut);

        // Crear documento en Firestore
        Usuario nuevoUsuario = Usuario(
          uid: user.uid,
          nombres: nombres,
          apellidos: apellidos,
          rut: rut,
          email: email,
          rol: isPsicologo ? 'psicologo' : 'paciente',
          celular: celular,
          psicologoAsignado: isPsicologo ? null : '', // Inicialmente sin asignar
        );

        await _firestore.collection('users').doc(user.uid).set(nuevoUsuario.toMap());

        return nuevoUsuario;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error en registro: $e');
      return null;
    }
  }

  // Inicio de sesión
  Future<Usuario?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Obtener datos del usuario desde Firestore
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          return Usuario.fromMap(userDoc.data() as Map<String, dynamic>);
        } else {
          // Si el documento no existe, cerrar sesión
          await signOut();
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error en inicio de sesión: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Verificar si el RUT está autorizado como psicólogo
  Future<bool> _isRutAuthorized(String rut) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('psicologos_autorizados')
          .where('rut', isEqualTo: rut)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      _logger.e('Error al verificar RUT: $e');
      return false;
    }
  }

  // Stream para observar cambios en la autenticación
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
