// lib/services/mock_service.dart
import 'package:sanamente/models/usuario.dart';
import '../models/rol.dart'; // Asegurarse de importar el enum Rol

class MockService {
  // Simula una base de datos de la universidad
  static final Map<String, Map<String, String>> _mockDatabase = {
    '12345678': {
      'rut': '12345678',
      'nombres': 'Juan',
      'apellidos': 'Pérez',
      'rol': 'psicologo', // Reemplazar 'tipo_usuario' con 'rol'
      'correo': 'juan.perez@universidad.cl',
      'campus': 'Santiago',
    },
    '87654321': {
      'rut': '87654321',
      'nombres': 'María',
      'apellidos': 'Gómez',
      'rol': 'paciente', // Reemplazar 'tipo_usuario' con 'rol'
      'correo': 'maria.gomez@universidad.cl',
      'campus': 'Valparaíso',
    },
  };

  // Método para validar un RUT
  static Future<Map<String, String>?> validarRut(String rut) async {
    // Simula una espera como si fuera una consulta real
    await Future.delayed(const Duration(seconds: 1));

    // Retorna los datos si el RUT está en la base simulada
    return _mockDatabase[rut];
  }

  // Método para agregar un usuario al Mock (si es necesario)
  static void agregarUsuario(Usuario usuario) {
    _mockDatabase[usuario.rut.toString()] = {
      'rut': usuario.rut.toString(),
      'nombres': usuario.nombres,
      'apellidos': usuario.apellidos,
      'rol': usuario.rol.name, // Asignar rol como String
      'correo': usuario.email,
      'campus': usuario.campus ?? '',
      // Agrega otros campos si es necesario
    };
  }
}
