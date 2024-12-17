import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../models/usuario.dart';
import '../services/admin_service.dart';
import '../utils/extensions.dart'; 
import '../utils/validators.dart';
import '../models/sede.dart';
import '../models/carrera.dart';

class EditarUsuarioScreen extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<EditarUsuarioScreen> createState() => _EditarUsuarioScreenState();
}

class _EditarUsuarioScreenState extends State<EditarUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _rutController;
  late TextEditingController _emailController;
  late TextEditingController _celularController;
  late TextEditingController _edadController;
  late TextEditingController _psicologoAsignadoController;

  Sede? _selectedSede;
  String? _selectedCarreraNombre;

  bool _isLoading = false;

  final List<Carrera> carreras = [
    
    Carrera(nombre: 'Arquitectura', sede: Sede.concepcion),
    Carrera(nombre: 'Diseño Industrial', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería en Construcción', sede: Sede.concepcion),
    Carrera(nombre: 'Programa de Bachillerato en Ciencias (Concepción)', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Estadística', sede: Sede.concepcion),
    Carrera(nombre: 'Contador Público y Auditor (Concepción)', sede: Sede.concepcion),
    Carrera(nombre: 'Derecho Carrera Nueva', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil en Informática (Concepción)', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Comercial (Concepción)', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería de Ejecución en Computación e Informática', sede: Sede.concepcion),
    Carrera(nombre: 'Trabajo Social (Concepción)', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil Eléctrica', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil en Automatización', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil Industrial', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil Mecánica', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Civil Química', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Eléctrica Carrera Nueva', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Electrónica Carrera Nueva', sede: Sede.concepcion),
    Carrera(nombre: 'Ingeniería Mecánica Carrera Nueva', sede: Sede.concepcion),

    
    Carrera(nombre: 'Diseño Gráfico', sede: Sede.chillan),
    Carrera(nombre: 'Programa de Bachillerato en Ciencias (Chillán)', sede: Sede.chillan),
    Carrera(nombre: 'Ingeniería en Recursos Naturales', sede: Sede.chillan),
    Carrera(nombre: 'Química y Farmacia', sede: Sede.chillan),
    Carrera(nombre: 'Enfermería', sede: Sede.chillan),
    Carrera(nombre: 'Fonoaudiología', sede: Sede.chillan),
    Carrera(nombre: 'Ingeniería en Alimentos', sede: Sede.chillan),
    Carrera(nombre: 'Medicina', sede: Sede.chillan),
    Carrera(nombre: 'Nutrición y Dietética', sede: Sede.chillan),
    Carrera(nombre: 'Contador Público y Auditor (Chillán)', sede: Sede.chillan),
    Carrera(nombre: 'Ingeniería Civil en Informática (Chillán)', sede: Sede.chillan),
    Carrera(nombre: 'Ingeniería Comercial (Chillán)', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Castellano y Comunicación', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Ciencias Naturales mención Biología o Física o Química', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Educación Especial con mención en Dificultades Específicas del Aprendizaje', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Educación Física', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Educación General Básica con mención en Lenguaje y Comunicación o Educación Matemática', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Educación Matemática', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Educación Parvularia Mención Didáctica en Primera Infancia', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Historia y Geografía', sede: Sede.chillan),
    Carrera(nombre: 'Pedagogía en Inglés', sede: Sede.chillan),
    Carrera(nombre: 'Psicología', sede: Sede.chillan),
    Carrera(nombre: 'Trabajo Social (Chillán)', sede: Sede.chillan),
  ];

  
  List<String> get _carrerasFiltradas {
    if (_selectedSede == null) return [];
    return carreras
        .where((c) => c.sede == _selectedSede)
        .map((c) => c.nombre)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController(text: widget.usuario.nombres);
    _apellidosController = TextEditingController(text: widget.usuario.apellidos);
    _rutController = TextEditingController(text: widget.usuario.rut);
    _emailController = TextEditingController(text: widget.usuario.email);
    _celularController = TextEditingController(text: widget.usuario.celular ?? '');
    _edadController = TextEditingController(text: widget.usuario.edad.toString());
    _psicologoAsignadoController =
        TextEditingController(text: widget.usuario.psicologoAsignado ?? '');

    
    _selectedSede = widget.usuario.campus != null
        ? (widget.usuario.campus!.toLowerCase() == 'concepción'
            ? Sede.concepcion
            : (widget.usuario.campus!.toLowerCase() == 'chillán'
                ? Sede.chillan
                : null))
        : null;

    // Asignar la carrera basada en el campus y el nombre
    _selectedCarreraNombre = widget.usuario.carrera.isNotEmpty
        ? widget.usuario.carrera
        : null;
  }

  void _editarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    // Validar sede y carrera solo si el usuario es paciente
    if (widget.usuario.rol == Rol.paciente &&
        (_selectedSede == null || _selectedCarreraNombre == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona la sede y la carrera.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final adminService = Provider.of<AdminService>(context, listen: false);

      Usuario updatedUsuario = Usuario(
        uid: widget.usuario.uid,
        rut: _rutController.text.trim(),
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        email: _emailController.text.trim(),
        rol: widget.usuario.rol,
        celular: _celularController.text.trim().isNotEmpty
            ? _celularController.text.trim()
            : null,
        psicologoAsignado: widget.usuario.rol == Rol.paciente
            ? _psicologoAsignadoController.text.trim()
            : null,
        campus: _selectedSede != null
            ? (_selectedSede == Sede.concepcion ? 'Concepción' : 'Chillán')
            : widget.usuario.campus,
        carrera: widget.usuario.rol == Rol.paciente
            ? _selectedCarreraNombre!
            : '', // Si no es paciente, la carrera será una cadena vacía
        edad: int.parse(_edadController.text.trim()),
      );

      await adminService.editarUsuario(updatedUsuario);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario actualizado exitosamente.')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar usuario: $e')),
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
    _emailController.dispose();
    _celularController.dispose();
    _edadController.dispose();
    _psicologoAsignadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPaciente = widget.usuario.rol == Rol.paciente;

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${widget.usuario.rol.name.capitalize()}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo de Nombres
                TextFormField(
                  controller: _nombresController,
                  decoration: const InputDecoration(labelText: 'Nombres'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingresa los nombres.' : null,
                ),
                const SizedBox(height: 16),

                // Campo de Apellidos
                TextFormField(
                  controller: _apellidosController,
                  decoration: const InputDecoration(labelText: 'Apellidos'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Ingresa los apellidos.' : null,
                ),
                const SizedBox(height: 16),

                // Campo de RUT (no editable)
                TextFormField(
                  controller: _rutController,
                  decoration: const InputDecoration(
                    labelText: 'RUT',
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),

                // Campo de Edad
                TextFormField(
                  controller: _edadController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    int? edad = int.tryParse(value ?? '');
                    if (edad == null || edad < 18 || edad > 100) {
                      return 'Edad inválida. Debe ser entre 18 y 100 años.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de Correo Electrónico
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validarEmail(value ?? '') ? null : 'Correo inválido.',
                ),
                const SizedBox(height: 16),

                // Campo de Celular (Opcional)
                TextFormField(
                  controller: _celularController,
                  decoration: const InputDecoration(labelText: 'Celular (opcional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Campo de Psicólogo Asignado (solo para Pacientes)
                if (isPaciente)
                  TextFormField(
                    controller: _psicologoAsignadoController,
                    decoration: const InputDecoration(labelText: 'Psicólogo Asignado'),
                    validator: (value) {
                      if (isPaciente && (value == null || value.isEmpty)) {
                        return 'Por favor, asigna un psicólogo.';
                      }
                      return null;
                    },
                  ),
                if (isPaciente) const SizedBox(height: 16),

                // Dropdown de Campus
                DropdownButtonFormField<Sede>(
                  value: _selectedSede,
                  decoration: const InputDecoration(labelText: 'Campus'),
                  items: Sede.values.map((sede) {
                    return DropdownMenuItem<Sede>(
                      value: sede,
                      child: Text(sede.name.capitalize()),
                    );
                  }).toList(),
                  onChanged: (Sede? sede) {
                    setState(() {
                      _selectedSede = sede;
                      _selectedCarreraNombre = null; // Reset carrera
                    });
                  },
                  validator: (value) => value == null ? 'Selecciona una sede.' : null,
                ),
                const SizedBox(height: 16),

                // Dropdown de Carrera solo para Pacientes
                if (isPaciente)
                  DropdownButtonFormField<String>(
                    value: _selectedCarreraNombre,
                    decoration: const InputDecoration(labelText: 'Carrera'),
                    items: _carrerasFiltradas.map((nombre) {
                      return DropdownMenuItem<String>(
                        value: nombre,
                        child: Text(nombre),
                      );
                    }).toList(),
                    onChanged: (carrera) {
                      setState(() {
                        _selectedCarreraNombre = carrera;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Selecciona una carrera.' : null,
                  ),
                if (isPaciente) const SizedBox(height: 16),

                // Botón de Guardar Cambios
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _editarUsuario,
                        child: const Text('Guardar Cambios'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
