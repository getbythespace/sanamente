// lib/models/rol.dart

enum Rol { paciente, psicologo, admin }

extension RolExtension on Rol {
  String get name {
    switch (this) {
      case Rol.paciente:
        return 'paciente';
      case Rol.psicologo:
        return 'psicologo';
      case Rol.admin:
        return 'admin';
    }
  }

  static Rol? fromString(String rol) {
    switch (rol.toLowerCase()) {
      case 'paciente':
        return Rol.paciente;
      case 'psicologo':
        return Rol.psicologo;
      case 'admin':
        return Rol.admin;
      default:
        return null;
    }
  }
}
