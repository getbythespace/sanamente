class Usuario {
  final String uid;
  final String nombres;
  final String apellidos;
  final String rut;
  final String email;
  final String rol;
  final String? celular; // Opcional
  final String? psicologoAsignado; // Para pacientes, nulo si no tienen psicólogo

  Usuario({
    required this.uid,
    required this.nombres,
    required this.apellidos,
    required this.rut,
    required this.email,
    required this.rol,
    this.celular,
    this.psicologoAsignado,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      rut: map['rut'],
      email: map['email'],
      rol: map['rol'],
      celular: map['celular'],
      psicologoAsignado: map['psicologoAsignado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombres': nombres,
      'apellidos': apellidos,
      'rut': rut,
      'email': email,
      'rol': rol,
      'celular': celular,
      'psicologoAsignado': psicologoAsignado,
    };
  }
}
