// lib/screens/grafico_detallado_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/encuesta_service.dart';
import '../models/encuesta.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';

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
    final encuestaService = Provider.of<EncuestaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final Usuario? usuario = await authService.currentUser;

    if (usuario != null) {
      // Obtener todas las encuestas del mes actual
      DateTime firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
      DateTime lastDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);

      List<Encuesta> encuestas = await encuestaService.getEncuestasByDateRange(
        usuario.uid,
        firstDayOfMonth,
        lastDayOfMonth,
      );

      setState(() {
        _encuestas = encuestas;
      });
    }
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _focusedMonth = newMonth;
      _selectedDay = newMonth;
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
        fecha: selectedDay,
        bienestar: 0,
      ),
    );

    if (encuesta.id.isNotEmpty) {
      // Mostrar detalles de la encuesta
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Detalles del ${selectedDay.toLocal().toString().split(' ')[0]}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bienestar: ${encuesta.bienestar}'),
              if (encuesta.motivacion != null) Text('Motivación: ${encuesta.motivacion}'),
              if (encuesta.comentario != null) Text('Comentario: ${encuesta.comentario}'),
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
    // Procesar datos para el gráfico
    List<FlSpot> spots = [];
    for (int i = 0; i < _encuestas.length; i++) {
      spots.add(FlSpot(i.toDouble(), _encuestas[i].bienestar.toDouble()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico Anímico General'),
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
                    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
                  });
                  _onMonthChanged(_focusedMonth);
                },
              ),
              Text(
                '${_focusedMonth.month}/${_focusedMonth.year}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
                  });
                  _onMonthChanged(_focusedMonth);
                },
              ),
            ],
          ),
          // Gráfico Anímico
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  minX: 0,
                  maxX: _encuestas.length > 0 ? (_encuestas.length - 1).toDouble() : 1,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      barWidth: 3,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Calendario
          Expanded(
            flex: 3,
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedMonth,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedMonth = focusedDay;
                _onMonthChanged(_focusedMonth);
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final encuesta = _encuestas.firstWhere(
                    (e) => isSameDay(e.fecha, date),
                    orElse: () => Encuesta(
                      id: '',
                      usuarioId: '',
                      fecha: date,
                      bienestar: 0,
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
