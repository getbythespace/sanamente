// lib\models\usuario.dart
import 'rol.dart';
import 'sede.dart';

class Usuario {
  final String uid;
  final String rut;
  final String nombres;
  final String apellidos;
  final String email;
  final Rol rol;
  final String? celular;
  final String? psicologoAsignado;
  final String campus;
  final String carrera;
  final int edad;

  Usuario({
    required this.uid,
    required this.rut,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.rol,
    this.celular,
    this.psicologoAsignado,
    required this.campus,
    required this.carrera,
    required this.edad,
  });

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      uid: data['uid'] ?? '',
      rut: data['rut'] ?? '',
      nombres: data['nombres'] ?? '',
      apellidos: data['apellidos'] ?? '',
      email: data['email'] ?? '',
      rol: RolExtension.fromString(data['rol']) ?? Rol.paciente,
      celular: data['celular'],
      psicologoAsignado: data['psicologoAsignado'],
      campus: data['campus'] ?? '',
      carrera: data['carrera'] ?? '',
      edad: data['edad'] ?? 0,
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
      'carrera': carrera,
      'edad': edad,
    };
  }
}
