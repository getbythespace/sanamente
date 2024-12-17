import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../models/encuesta.dart';
import '../services/encuesta_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart'; 

class PerfilPacienteScreen extends StatefulWidget {
  final Usuario paciente;

  const PerfilPacienteScreen({Key? key, required this.paciente}) : super(key: key);

  @override
  _PerfilPacienteScreenState createState() => _PerfilPacienteScreenState();
}

class _PerfilPacienteScreenState extends State<PerfilPacienteScreen> {
  DateTime _focusedMonth = DateTime.now();
  List<Encuesta> _encuestas = [];

  @override
  void initState() {
    super.initState();
    _loadEncuestas();
  }

  void _loadEncuestas() async {
    final encuestaService = Provider.of<EncuestaService>(context, listen: false);
    DateTime firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

    try {
      List<Encuesta> encuestas = await encuestaService.getEncuestasByDateRange(
        usuarioId: widget.paciente.uid,
        psicologoId: widget.paciente.psicologoAsignado ?? '',
        start: firstDayOfMonth,
        end: lastDayOfMonth,
      );

      setState(() {
        _encuestas = encuestas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar encuestas: $e')),
      );
      setState(() {
        _encuestas = [];
      });
    }
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _focusedMonth = newMonth;
    });
    _loadEncuestas();
  }

  @override
  Widget build(BuildContext context) {
    // Procesar datos para el gráfico
    List<FlSpot> spots = [];
    for (int i = 0; i < _encuestas.length; i++) {
      spots.add(FlSpot(i.toDouble(), _encuestas[i].bienestar.toDouble()));
    }

    bool hasValidData = spots.isNotEmpty &&
        spots.length > 1 && 
        spots.every((spot) => spot.y.isFinite) &&
        spots.every((spot) => spot.x.isFinite);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de ${widget.paciente.nombres}'),
      ),
      body: Column(
        children: [
          // Información Básica
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text('${widget.paciente.nombres} ${widget.paciente.apellidos}'),
                  subtitle: Text('Carrera: ${widget.paciente.carrera}'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(widget.paciente.email),
                ),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(widget.paciente.celular ?? 'No proporcionado'),
                ),
              ],
            ),
          ),
          // Gráfico Anímico
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: hasValidData
                ? SizedBox(
                    height: 300, 
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                
                                return Text(''); // Vacío para simplificar
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        minX: 0,
                        maxX: _encuestas.length > 1 ? (_encuestas.length - 1).toDouble() : 1,
                        minY: 0,
                        maxY: 10,
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.red,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 300, 
                    child: Center(
                      child: Text(
                        'No hay datos válidos para el gráfico.',
                        style: TextStyle(color: Colors.red),
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
              selectedDayPredicate: (day) => false,
              onPageChanged: _onMonthChanged,
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final encuesta = _encuestas.firstWhere(
                    (e) => isSameDay(e.fecha, date),
                    orElse: () => Encuesta(
                      id: '',
                      usuarioId: '',
                      psicologoId: '', 
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
                        color: Colors.red,
                      ),
                    );
                  }
                  return null;
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
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
                      title: Text('Detalles del ${DateFormat('yyyy-MM-dd').format(selectedDay)}'),
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
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMoodIcon(int bienestar) {
    if (bienestar <= 3) return Icons.sentiment_very_dissatisfied;
    if (bienestar <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_very_satisfied;
  }
}
