import 'rol.dart'; 
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
    this.campus,
    required this.carrera,
    required this.edad,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      rut: map['rut'] ?? '',
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      email: map['email'] ?? '',
      rol: RolExtension.fromString(map['rol']) ?? Rol.paciente,
      celular: map['celular'],
      psicologoAsignado: map['psicologoAsignado'],
      campus: map['campus'],
      carrera: map['carrera'] ?? '',
      edad: map['edad'] ?? 18,
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
      'campus': campus, //dejar campus o sede?
      'carrera': carrera,
      'edad': edad,
    };
  }
}
