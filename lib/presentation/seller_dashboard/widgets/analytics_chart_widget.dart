import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsChartWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> chartData;
  final String chartType;
  final Color? primaryColor;

  const AnalyticsChartWidget({
    super.key,
    required this.title,
    required this.chartData,
    this.chartType = 'line',
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final color = primaryColor ?? colorScheme.primary;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1), width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 4.w),
          SizedBox(
              height: 40.w,
              child: chartType == 'bar'
                  ? _buildBarChart(colorScheme, color)
                  : _buildLineChart(colorScheme, color)),
        ]));
  }

  Widget _buildLineChart(ColorScheme colorScheme, Color color) {
    final spots = chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(
          index.toDouble(), ((data["value"] as num?) ?? 0).toDouble());
    }).toList();

    return LineChart(LineChartData(
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1);
            }),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < chartData.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                                (chartData[index]["label"] as String?) ?? "",
                                style: TextStyle(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    fontSize: 10.sp)));
                      }
                      return const SizedBox();
                    })),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(value.toInt().toString(),
                          style: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 10.sp));
                    },
                    reservedSize: 32))),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (chartData.length - 1).toDouble(),
        minY: 0,
        maxY: spots.isNotEmpty
            ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2
            : 10,
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(colors: [
                color,
                color.withValues(alpha: 0.7),
              ]),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: color,
                        strokeWidth: 2,
                        strokeColor: Colors.white);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.1),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
        ]));
  }

  Widget _buildBarChart(ColorScheme colorScheme, Color color) {
    final barGroups = chartData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: ((data["value"] as num?) ?? 0).toDouble(),
            color: color,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      ]);
    }).toList();

    return BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: barGroups.isNotEmpty
            ? barGroups
                    .map((group) => group.barRods.first.toY)
                    .reduce((a, b) => a > b ? a : b) *
                1.2
            : 10,
        barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                      '${chartData[group.x]["label"]}\n${rod.toY.round()}',
                      TextStyle(
                          color: colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold));
                })),
        titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < chartData.length) {
                        return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                                (chartData[index]["label"] as String?) ?? "",
                                style: TextStyle(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                    fontSize: 10.sp)));
                      }
                      return const SizedBox();
                    },
                    reservedSize: 38)),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text(value.toInt().toString(),
                          style: TextStyle(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              fontSize: 10.sp));
                    }))),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1);
            })));
  }
}
