import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/encuesta.dart';
import '../models/usuario.dart';
import '../services/encuesta_service.dart';
import '../services/auth_service.dart';

class NuevoAnimoScreen extends StatefulWidget {
  const NuevoAnimoScreen({Key? key}) : super(key: key);

  @override
  _NuevoAnimoScreenState createState() => _NuevoAnimoScreenState();
}

class _NuevoAnimoScreenState extends State<NuevoAnimoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _bienestar = 5;
  int? _motivacion;
  String? _comentario;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_motivacion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, responde ambas preguntas.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final encuestaService =
          Provider.of<EncuestaService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final Usuario? usuario = await authService.currentUser;

      if (usuario == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario no autenticado')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (usuario.psicologoAsignado == null ||
          usuario.psicologoAsignado!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tienes un psicólogo asignado.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Encuesta nuevaEncuesta = Encuesta(
        id: '',
        usuarioId: usuario.uid,
        psicologoId: usuario.psicologoAsignado!,
        fecha: DateTime.now(),
        bienestar: _bienestar,
        motivacion: _motivacion,
        comentario: _comentario,
      );

      await encuestaService.addEncuesta(nuevaEncuesta);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ánimo registrado exitosamente')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar ánimo: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nuevo Estado de Ánimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pregunta para Bienestar
              const Text(
                "1. En general, ¿cómo te has sentido emocionalmente hoy?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _bienestar.toDouble(),
                min: 1,
                max: 10,
                divisions: 10,
                label: _bienestar.toString(),
                onChanged: (double value) {
                  setState(() {
                    _bienestar = value.toInt();
                  });
                },
              ),
              const Text("(1 = Muy mal, 10 = Muy bien)",
                  style: TextStyle(fontSize: 12)),

              const SizedBox(height: 24),

              // Pregunta para Motivación
              const Text(
                "2. ¿Qué tan motivado te sientes para realizar tus actividades hoy?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Motivación'),
                value: _motivacion,
                items: List.generate(10, (index) => index + 1)
                    .map((motivacion) => DropdownMenuItem<int>(
                          value: motivacion,
                          child: Text(motivacion.toString()),
                        ))
                    .toList(),
                onChanged: (int? value) {
                  setState(() {
                    _motivacion = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecciona tu nivel de motivación.' : null,
              ),
              const Text("(1 = Nada motivado, 10 = Muy motivado)",
                  style: TextStyle(fontSize: 12)),

              const SizedBox(height: 24),

              // Comentarios opcionales
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                ),
                onChanged: (value) {
                  _comentario = value;
                },
              ),

              const SizedBox(height: 32),

              // Botón de guardar
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Guardar'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
