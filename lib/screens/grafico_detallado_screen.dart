import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/encuesta_service.dart';
import '../models/encuesta.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../widgets/mood_chart_syncfusion.dart';
import 'package:intl/intl.dart'; 

class GraficoDetalladoScreen extends StatefulWidget {
  const GraficoDetalladoScreen({Key? key}) : super(key: key);

  @override
  _GraficoDetalladoScreenState createState() => _GraficoDetalladoScreenState();
}

class _GraficoDetalladoScreenState extends State<GraficoDetalladoScreen> {
  DateTime _focusedMonth = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Encuesta> _encuestas = [];

  @override
  void initState() {
    super.initState();
    _loadEncuestas();
  }

  void _loadEncuestas() async {
    final encuestaService =
        Provider.of<EncuestaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final Usuario? usuario = await authService.currentUser;

    if (usuario != null) {
      DateTime firstDayOfMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month, 1);
      DateTime lastDayOfMonth =
          DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

      debugPrint(
          'Cargando encuestas para el usuario: ${usuario.uid} con psicólogo: ${usuario.psicologoAsignado}');
      debugPrint(
          'Rango de fechas: ${firstDayOfMonth.toIso8601String()} - ${lastDayOfMonth.toIso8601String()}');

      try {
        List<Encuesta> encuestas =
            await encuestaService.getEncuestasByDateRange(
          usuarioId: usuario.uid,
          psicologoId: usuario.psicologoAsignado ?? '',
          start: firstDayOfMonth,
          end: lastDayOfMonth,
        );

        debugPrint('Encuestas obtenidas antes de filtrar: ${encuestas.length}');
        
        encuestas = encuestas.where((e) {
          return e.bienestar >= 0 && e.bienestar <= 10;
        }).toList();
        debugPrint('Encuestas después de filtrar: ${encuestas.length}');

        setState(() {
          _encuestas = encuestas;
        });

        
        for (final encuesta in encuestas) {
          debugPrint(
              'Encuesta: bienestar=${encuesta.bienestar}, fecha=${encuesta.fecha}');
        }
      } catch (e, stackTrace) {
        debugPrint('Error al cargar encuestas: $e');
        debugPrint('StackTrace: $stackTrace');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar encuestas: $e')),
        );
        setState(() {
          _encuestas = [];
        });
      }
    } else {
      debugPrint('Usuario actual es null');
      
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _focusedMonth = newMonth;
    });
    _loadEncuestas();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedMonth = focusedDay;
    });

    Encuesta? encuesta = _encuestas.firstWhere(
      (e) => isSameDay(e.fecha, selectedDay),
      orElse: () => Encuesta(
        id: '',
        usuarioId: '',
        psicologoId: '', 
        fecha: selectedDay,
        bienestar: 0,
        motivacion: null,
        comentario: null,
      ),
    );

    if (encuesta.id.isNotEmpty) {
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              'Detalles del ${DateFormat('yyyy-MM-dd').format(selectedDay)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bienestar: ${encuesta.bienestar}'),
              if (encuesta.motivacion != null)
                Text('Motivación: ${encuesta.motivacion}'),
              if (encuesta.comentario != null)
                Text('Comentario: ${encuesta.comentario}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  IconData _getMoodIcon(int bienestar) {
    if (bienestar <= 3) return Icons.sentiment_very_dissatisfied;
    if (bienestar <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_very_satisfied;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico Anímico Detallado'),
      ),
      body: Column(
        children: [
          // Navegación de Meses
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                        _focusedMonth.year, _focusedMonth.month - 1, 1);
                  });
                  _onMonthChanged(_focusedMonth);
                },
              ),
              Text(
                '${_focusedMonth.month}/${_focusedMonth.year}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(
                        _focusedMonth.year, _focusedMonth.month + 1, 1);
                  });
                  _onMonthChanged(_focusedMonth);
                },
              ),
            ],
          ),
          // Gráfico Anímico con Syncfusion
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _encuestas.isNotEmpty
                ? SizedBox(
                    height: 300, // Proporcionar una altura fija
                    child: MoodChartSyncfusion(encuestas: _encuestas),
                  )
                : const SizedBox(
                    height: 300, // Proporcionar una altura fija
                    child: Center(
                      child: Text(
                        'No hay datos para mostrar el gráfico.',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
          ),
          // Calendario
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedMonth,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: _onDaySelected,
              onPageChanged: _onMonthChanged,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final encuesta = _encuestas.firstWhere(
                    (e) => isSameDay(e.fecha, date),
                    orElse: () => Encuesta(
                      id: '',
                      usuarioId: '',
                      psicologoId: '', // Proporcionar 'psicologoId'
                      fecha: date,
                      bienestar: 0,
                      motivacion: null,
                      comentario: null,
                    ),
                  );

                  if (encuesta.id.isNotEmpty) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        _getMoodIcon(encuesta.bienestar),
                        size: 16,
                        color: Colors.blue,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
