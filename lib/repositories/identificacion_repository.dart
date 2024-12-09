import '../models/usuario.dart';

abstract class IdentificacionRepository {
  Future<Usuario?> obtenerUsuarioPorRut(String rut); // Cambiar uid a rut
  Future<void> saveUsuario(Usuario usuario); 
}