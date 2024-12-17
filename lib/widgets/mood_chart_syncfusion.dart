// lib/widgets/mood_chart_syncfusion.dart

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/encuesta.dart';
import '../models/mood_data.dart';
import 'package:intl/intl.dart';

class MoodChartSyncfusion extends StatelessWidget {
  final List<Encuesta> encuestas;

  const MoodChartSyncfusion({Key? key, required this.encuestas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Preparar los datos para el gráfico
    List<MoodData> chartData = encuestas
        .map((encuesta) => MoodData(encuesta.fecha, encuesta.bienestar))
        .toList();

    // Ordenar los datos por fecha
    chartData.sort((a, b) => a.fecha.compareTo(b.fecha));

    return SfCartesianChart(
      title: ChartTitle(text: 'Gráfico de Bienestar Mensual'),
      primaryXAxis: DateTimeAxis(
        intervalType: DateTimeIntervalType.days,
        dateFormat: DateFormat.Md(),
        majorGridLines: const MajorGridLines(width: 0.5),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 10,
        interval: 2,
        majorGridLines: const MajorGridLines(width: 0.5),
        axisLine: const AxisLine(width: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[
        LineSeries<MoodData, DateTime>(
          dataSource: chartData,
          xValueMapper: (MoodData data, _) => data.fecha,
          yValueMapper: (MoodData data, _) => data.bienestar,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          color: Colors.blue,
          width: 2,
        )
      ],
    );
  }
}
