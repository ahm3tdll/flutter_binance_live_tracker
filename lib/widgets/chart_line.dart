import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_binance_tracker/model/chart_model.dart';

class ChartLine extends StatelessWidget {
  final List<ChartDataModel> data;

  const ChartLine({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              interval: 5,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                );
              },
  ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (value, meta) {
                final int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final date = data[index].time;
                  return Text(
                    "${date.day}/${date.month}",
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value.close))
                .toList(),
            isCurved: true,
            barWidth: 2,
            color: Colors.greenAccent,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
