import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/sede.dart' as sedeModelo; 
import '../models/carrera.dart' as carreraModel;
import '../utils/validators.dart';
import '../models/rol.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();

  sedeModelo.Sede? _selectedSede;
  String? _selectedCarreraNombre;

  bool _isLoading = false;

  
  final List<carreraModel.Carrera> carreras = [
    
carreraModel.Carrera(nombre: 'Arquitectura', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Diseño Industrial', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería en Construcción', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Programa de Bachillerato en Ciencias (Concepción)', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Estadística', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Contador Público y Auditor (Concepción)', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Derecho Carrera Nueva', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil en Informática (Concepción)', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Comercial (Concepción)', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería de Ejecución en Computación e Informática', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Trabajo Social (Concepción)', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil Eléctrica', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil en Automatización', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil Industrial', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil Mecánica', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Civil Química', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Eléctrica Carrera Nueva', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Electrónica Carrera Nueva', sede: sedeModelo.Sede.concepcion),
carreraModel.Carrera(nombre: 'Ingeniería Mecánica Carrera Nueva', sede: sedeModelo.Sede.concepcion),


carreraModel.Carrera(nombre: 'Diseño Gráfico', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Programa de Bachillerato en Ciencias (Chillán)', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Ingeniería en Recursos Naturales', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Química y Farmacia', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Enfermería', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Fonoaudiología', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Ingeniería en Alimentos', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Medicina', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Nutrición y Dietética', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Contador Público y Auditor (Chillán)', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Ingeniería Civil en Informática (Chillán)', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Ingeniería Comercial (Chillán)', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Castellano y Comunicación', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Ciencias Naturales mención Biología o Física o Química', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Educación Especial con mención en Dificultades Específicas del Aprendizaje', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Educación Física', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Educación General Básica con mención en Lenguaje y Comunicación o Educación Matemática', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Educación Matemática', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Educación Parvularia Mención Didáctica en Primera Infancia', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Historia y Geografía', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Pedagogía en Inglés', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Psicología', sede: sedeModelo.Sede.chillan),
carreraModel.Carrera(nombre: 'Trabajo Social (Chillán)', sede: sedeModelo.Sede.chillan),

  ];

  
  List<String> get _carrerasFiltradas {
    if (_selectedSede == null) return [];
    return carreras
        .where((c) => c.sede == _selectedSede)
        .map((c) => c.nombre)
        .toList();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    
    if (_selectedSede == null || _selectedCarreraNombre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final edad = int.tryParse(_edadController.text.trim());

      
      if (edad == null || edad < 18 || edad > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edad inválida. Debe ser entre 18 y 100 años.')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Registro default como paciente 
      await authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        rut: _rutController.text.trim(),
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        rol: Rol.paciente, // Fijar rol como paciente
        celular: _celularController.text.trim().isNotEmpty
            ? _celularController.text.trim()
            : null,
        psicologoAsignado: null,
        campus: _selectedSede == sedeModelo.Sede.concepcion ? 'Concepción' : 'Chillán',
        carrera: _selectedCarreraNombre!,
        edad: edad,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso.')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Error al registrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _rutController.dispose();
    _edadController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                const Text(
                  'Estás registrándote como paciente. Si requieres otro rol, contacta al administrador.',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Campo Nombres
                TextFormField(
                  controller: _nombresController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingresa tus nombres.' : null,
                ),
                const SizedBox(height: 16),

                // Campo Apellidos
                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                  ),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingresa tus apellidos.' : null,
                ),
                const SizedBox(height: 16),

                // Campo RUT 
                TextFormField(
                  controller: _rutController,
                  decoration: const InputDecoration(
                    labelText: 'RUT',
                    helperText: 'Formato: sin puntos ni guión (Ej: 12345678K)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu RUT.';
                    }
                    if (!validarRut(value)) {
                      return 'RUT inválido (usa sin puntos ni guión).';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Edad
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(
                    labelText: 'Edad',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingresa tu edad.' : null,
                ),
                const SizedBox(height: 16),

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu correo.';
                    }
                    if (!validarEmail(value)) {
                      return 'Correo inválido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña.';
                    }
                    if (value.length < 6) {
                      return 'Debe tener al menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Celular (opcional)
                TextFormField(
                  controller: _celularController,
                  decoration: const InputDecoration(
                    labelText: 'Celular (opcional)',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Dropdown Sede
                DropdownButtonFormField<sedeModelo.Sede>(
                  value: _selectedSede,
                  decoration: const InputDecoration(labelText: 'Sede'),
                  items: sedeModelo.Sede.values.map((sedeValue) {
                    return DropdownMenuItem<sedeModelo.Sede>(
                      value: sedeValue,
                      child: Text(sedeValue.name),
                    );
                  }).toList(),
                  onChanged: (sedeModelo.Sede? newSede) {
                    setState(() {
                      _selectedSede = newSede;
                      _selectedCarreraNombre = null; // Reset
                    });
                  },
                  validator: (value) =>
                      (value == null) ? 'Selecciona una sede.' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown Carrera
                DropdownButtonFormField<String>(
                  value: _selectedCarreraNombre,
                  decoration: const InputDecoration(labelText: 'Carrera'),
                  items: _carrerasFiltradas.map((nombre) {
                    return DropdownMenuItem<String>(
                      value: nombre,
                      child: Text(nombre),
                    );
                  }).toList(),
                  onChanged: (String? newCarrera) {
                    setState(() {
                      _selectedCarreraNombre = newCarrera;
                    });
                  },
                  validator: (value) =>
                      (value == null) ? 'Selecciona una carrera.' : null,
                ),
                const SizedBox(height: 32),

                // Botón de Registro
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Registrarse'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
