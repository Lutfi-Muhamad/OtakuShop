import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  final Map<String, int> salesData = const {'Mon': 120, 'Tue': 180};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEEF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF87DAF),
        elevation: 0,
        title: const Text(
          'Sales Report',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _HeaderCard(),
            SizedBox(height: 16),
            Expanded(child: _ChartCard()),
          ],
        ),
      ),
    );
  }
}

/// =============================
/// HEADER CARD
/// =============================
class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF87DAF), Color(0xFFFFA6C9)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'SALES IN 7 DAYS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

/// =============================
/// CHART CARD
/// =============================
class _ChartCard extends StatelessWidget {
  const _ChartCard();

  final List<String> orderedDays = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final Map<String, int> salesData = const {'Mon': 120, 'Tue': 180};

  @override
  Widget build(BuildContext context) {
    final visibleDays = orderedDays
        .where((d) => salesData.containsKey(d))
        .toList();

    // 👉 JIKA DATA KOSONG
    if (visibleDays.isEmpty) {
      return const Center(
        child: Text(
          'No sales data available',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
        ),
      );
    }

    final double maxY =
        salesData.values.reduce((a, b) => a > b ? a : b).toDouble() + 50;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.15),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  // 👉 GUARD INDEX
                  if (index < 0 || index >= visibleDays.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      visibleDays[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(visibleDays.length, (index) {
            final day = visibleDays[index];
            final salesValue = salesData[day]!.toDouble();

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: salesValue,
                  width: 18,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF87DAF), Color(0xFFFFA6C9)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
