import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/logic/date.dart';
import 'package:weather_app/models/weather.dart';

const _chartTitle = 'Temperature';

class TemperatureChart extends StatelessWidget {
  TemperatureChart({
    super.key,
    this.titlePrefix,
    required this.minY,
    required this.maxY,
    required this.firstLineSpots,
    this.secondLineSpots,
  }) : _maxX = firstLineSpots.length.toDouble() - 1;

  final String? titlePrefix;
  final double minY;
  final double maxY;
  final List<FlSpot> firstLineSpots; // max temperature
  final List<FlSpot>? secondLineSpots; // min temperature

  final double _maxX;

  LineChartBarData _generateLineChartBarData(List<FlSpot> spots, Color color) =>
      LineChartBarData(
        color: color,
        spots: spots,
        isCurved: true,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
        ),
      );

  Widget horizontalSideTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('${value.toInt()} $temperatureUnit', style: style),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: _maxX < 23 || value != _maxX
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16),
              child: Transform.rotate(
                angle: 1,
                child: SizedBox(
                    width: 38,
                    child: Text(
                      _maxX < 23 ? generateMmDdDate(value) : '${value.toInt()}:00',
                      style: style,
                      textAlign: TextAlign.start,
                    )),
              ),
            )
          : const SizedBox(),
    );
  }

  AxisTitles _generateHorizontalAxisTitles() => AxisTitles(
        axisNameSize: 12,
        sideTitles: SideTitles(
          showTitles: true,
          interval: 5,
          reservedSize: 40,
          getTitlesWidget: horizontalSideTitleWidgets,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            horizontalInterval: 5,
            verticalInterval: _maxX >= 23 ? 2 : 1,
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.5),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.5),
              strokeWidth: 1,
            ),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
          minX: 0,
          maxX: _maxX,
          minY: minY,
          maxY: maxY,
          // lineTouchData: const LineTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: _generateHorizontalAxisTitles(),
            rightTitles: _generateHorizontalAxisTitles(),
            bottomTitles: AxisTitles(
              axisNameSize: 14,
              sideTitles: SideTitles(
                showTitles: true,
                interval: _maxX >= 23 ? 2 : 1,
                reservedSize: 40,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            topTitles: AxisTitles(
              // show the title "toto"
              axisNameSize: 40,
              axisNameWidget: Text(
                  titlePrefix != null
                      ? "$titlePrefix ${_chartTitle.toLowerCase()}"
                      : _chartTitle,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelLarge!.fontSize)),
            ),
          ),
          lineBarsData: [
            _generateLineChartBarData(firstLineSpots,
                secondLineSpots != null ? Colors.red : Colors.white),
            if (secondLineSpots != null)
              _generateLineChartBarData(secondLineSpots!, Colors.blue),
          ],
        ),
      ),
    );
  }
}
