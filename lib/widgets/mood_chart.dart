import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/encuesta.dart';
import '../models/usuario.dart';
import '../services/encuesta_service.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodChart extends StatefulWidget {
  final Usuario usuario;
  final VoidCallback onViewMore;

  const MoodChart({Key? key, required this.usuario, required this.onViewMore}) : super(key: key);

  @override
  _MoodChartState createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  List<Encuesta> _encuestas = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEncuestas();
  }

  void _loadEncuestas() async {
    final encuestaService = Provider.of<EncuestaService>(context, listen: false);
    try {
      List<Encuesta> encuestas = await encuestaService.getLatestEncuestas(widget.usuario.uid, limit: 10);
      setState(() {
        _encuestas = encuestas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar encuestas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text(_error!));
    }

    if (_encuestas.isEmpty) {
      return const Center(child: Text('No hay encuestas disponibles.'));
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < _encuestas.length; i++) {
      spots.add(FlSpot(i.toDouble(), _encuestas[i].bienestar.toDouble()));
    }

    // Validar que no haya valores Infinity
    bool hasValidData = spots.isNotEmpty &&
        spots.every((spot) => spot.y.isFinite) &&
        spots.every((spot) => spot.x.isFinite);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tu Gráfico Anímico',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        hasValidData
            ? SizedBox(
                height: 200,
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
                    maxX: _encuestas.length > 0 ? (_encuestas.length - 1).toDouble() : 0,
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
              )
            : const Text(
                'No hay datos válidos para mostrar el gráfico.',
                style: TextStyle(color: Colors.red),
              ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: widget.onViewMore,
          child: const Text('Ver Más'),
        ),
      ],
    );
  }
}
