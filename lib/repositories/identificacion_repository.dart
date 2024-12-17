import '../models/usuario.dart';
import '../models/rol.dart';

abstract class IdentificacionRepository {
  Future<Usuario?> obtenerUsuarioPorRut(String rut); 
  Future<Usuario?> obtenerUsuarioPorUid(String uid); 
  Future<void> saveUsuario(Usuario usuario); 
  Future<bool> isRutUnique(String rut); 
  Future<List<Usuario>> obtenerUsuariosPorRol(Rol rol); 
  Future<void> eliminarUsuario(String uid); 
  Future<List<Usuario>> obtenerTodosLosUsuarios(); 
}
