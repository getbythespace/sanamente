import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/rol.dart'; // enum Rol
import '../models/carrera.dart'; // Carrera
import '../utils/validators.dart'; //validador

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key}); // Constructor

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController edadController =
      TextEditingController(); //controlador para edad

  Sede? _sedeSeleccionada; // Variable para sede seleccionada
  Carrera? _carreraSeleccionada; // Variable para carrera seleccionada

  bool _isLoading = false;

  // Obtener las carreras filtradas según la sede seleccionada
  List<Carrera> get _carrerasFiltradas {
    if (_sedeSeleccionada == null) {
      return [];
    } else {
      return carreras
          .where((carrera) => carrera.sede == _sedeSeleccionada)
          .toList();
    }
  }

  void registrarUsuario(BuildContext context) async {
    final nombres = nombresController.text.trim();
    final apellidos = apellidosController.text.trim();
    final rut = rutController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final celular = celularController.text.trim();
    final edadTexto = edadController.text.trim();

    // Validar que todos los campos requeridos estén completos
    if (nombres.isEmpty ||
        apellidos.isEmpty ||
        rut.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        _sedeSeleccionada == null ||
        _carreraSeleccionada == null ||
        edadTexto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    // Validar RUT
    if (!validarRut(rut)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('RUT inválido. Por favor, verifica el formato.')),
      );
      return;
    }

    // Validar Email
    if (!validarEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo electrónico inválido.')),
      );
      return;
    }

    // Validar Edad
    int? edad = int.tryParse(edadTexto);
    if (edad == null || edad < 18 || edad > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Edad inválida. Debe ser entre 18 y 100 años.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final usuario = await authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        rut: rut,
        nombres: nombres,
        apellidos: apellidos,
        rol: Rol.paciente, // Usar el enum Rol
        celular: celular.isNotEmpty ? celular : null,
        psicologoAsignado: null,
        campus: _sedeSeleccionada == Sede.concepcion ? 'Concepción' : 'Chillán',
        carrera: _carreraSeleccionada!.nombre, // Asignar carrera seleccionada
        edad: edad, // Asignar edad
      );

      // Verificar inmediatamente después del await si el widget está montado
      if (!mounted) return;

      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso como ${usuario.rol.name}')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error al registrar. Intenta de nuevo.')),
        );
      }
    } catch (e) {
      if (!mounted)
        return; // Verificar si el widget sigue montado antes de usar BuildContext
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    } finally {
      if (mounted) {
        // Verificar si el widget sigue montado antes de llamar a setState
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    rutController.dispose();
    emailController.dispose();
    passwordController.dispose();
    celularController.dispose();
    edadController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de Nombres
              TextField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: 'Nombres'),
              ),
              // Campo de Apellidos
              TextField(
                controller: apellidosController,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              // Campo de RUT con Indicador de Formato
              TextField(
                controller: rutController,
                decoration: const InputDecoration(
                  labelText: 'RUT',
                  hintText: 'Ejemplo: 12.345.678-5',
                ),
                keyboardType: TextInputType.text, // Permitir letras para DV
              ),
              // Indicador de Formato debajo del RUT
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Formato: XX.XXX.XXX-Y (Ej: 12.345.678-5)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Selección de Sede
              DropdownButtonFormField<Sede>(
                value: _sedeSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Sede',
                ),
                items: Sede.values.map((Sede sede) {
                  return DropdownMenuItem<Sede>(
                    value: sede,
                    child: Text(
                      sede == Sede.concepcion ? 'Concepción' : 'Chillán',
                    ),
                  );
                }).toList(),
                onChanged: (Sede? nuevaSede) {
                  setState(() {
                    _sedeSeleccionada = nuevaSede;
                    _carreraSeleccionada =
                        null; // Resetear carrera seleccionada
                  });
                },
              ),
              const SizedBox(height: 16),
              // Selección de Carrera
              DropdownButtonFormField<Carrera>(
                value: _carreraSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Carrera',
                ),
                items: _carrerasFiltradas.map((Carrera carrera) {
                  return DropdownMenuItem<Carrera>(
                    value: carrera,
                    child: Text(carrera.nombre),
                  );
                }).toList(),
                onChanged: (Carrera? nuevaCarrera) {
                  setState(() {
                    _carreraSeleccionada = nuevaCarrera;
                  });
                },
                validator: (value) {
                  if (_sedeSeleccionada != null && value == null) {
                    return 'Por favor, selecciona una carrera.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de Edad
              TextField(
                controller: edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  hintText: 'Ejemplo: 25',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Campo de Correo Electrónico
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Campo de Contraseña
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Campo de Celular (Opcional)
              TextField(
                controller: celularController,
                decoration:
                    const InputDecoration(labelText: 'Celular (opcional)'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              // Botón de Registro o Indicador de Carga
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => registrarUsuario(context),
                      child: const Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
