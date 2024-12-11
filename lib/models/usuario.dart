// lib/models/usuario.dart

import 'rol.dart'; // Mantener solo los imports necesarios
import 'carrera.dart'; // Importar el modelo Carrera

class Usuario {
  final String uid;
  final String rut;
  final String nombres;
  final String apellidos;
  final String email;
  final Rol rol;
  final String? celular;
  final String? psicologoAsignado;
  final String? campus;
  final String carrera; // Nuevo campo
  final int edad; // Nuevo campo

  Usuario({
    required this.uid,
    required this.rut,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.rol,
    this.celular,
    this.psicologoAsignado,
    this.campus,
    required this.carrera, // Requerido
    required this.edad, // Requerido
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      rut: map['rut'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      email: map['email'],
      rol: Rol.values.firstWhere((e) => e.name == map['rol']),
      celular: map['celular'],
      psicologoAsignado: map['psicologoAsignado'],
      campus: map['campus'],
      carrera: map['carrera'], // Nuevo campo
      edad: map['edad'], // Nuevo campo
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'rut': rut,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'rol': rol.name,
      'celular': celular,
      'psicologoAsignado': psicologoAsignado,
      'campus': campus,
      'carrera': carrera, // Nuevo campo
      'edad': edad, // Nuevo campo
    };
  }
}
