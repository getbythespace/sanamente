class Usuario {
  final String uid;
  final String rut;
  final String nombres;
  final String apellidos;
  final String email;
  final String tipoUsuario;
  final String? celular;
  final String? psicologoAsignado;
  final String? campus;

  Usuario({
    required this.uid,
    required this.rut,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.tipoUsuario,
    this.celular,
    this.psicologoAsignado,
    this.campus,
  });

  // Serializar a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'rut': rut,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'tipoUsuario': tipoUsuario,
      'celular': celular,
      'psicologoAsignado': psicologoAsignado,
      'campus': campus,
    };
  }

  // Deserializar desde Map
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'],
      rut: map['rut'],
      nombres: map['nombres'],
      apellidos: map['apellidos'],
      email: map['email'],
      tipoUsuario: map['tipoUsuario'],
      celular: map['celular'],
      psicologoAsignado: map['psicologoAsignado'],
      campus: map['campus'],
    );
  }
}

