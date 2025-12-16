import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

enum ChartMode { weekly, monthly }

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  ChartMode mode = ChartMode.weekly;
  DateTime selectedMonth = DateTime.now();
  int selectedIndex = 6; // default hari ini

  late List<SalesDay> salesData;

  @override
  void initState() {
    super.initState();
    _loadWeekly();
  }

  void _loadWeekly() {
    final today = DateTime.now();
    salesData = List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      return SalesDay(
        date: date,
        totalSales: 40 + i * 25,
        products: ['Nendoroid Luffy', 'Figure Gojo', 'Anime Bag'],
      );
    });
    selectedIndex = salesData.length - 1;
  }

  void _loadMonthly(DateTime month) {
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    salesData = List.generate(days, (i) {
      return SalesDay(
        date: DateTime(month.year, month.month, i + 1),
        totalSales: (i % 6) * 30 + 20,
        products: ['Figure Naruto', 'Nendoroid Mikasa'],
      );
    });
    selectedIndex = days - 1;
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = salesData
        .map((e) => e.totalSales)
        .reduce((a, b) => a > b ? a : b);

    final maxY = ((maxValue / 50).ceil() * 50).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFFFEEF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF87DAF),
        title: const Text('Sales Report'),
        centerTitle: true,
      ),
      body: Column(
        children: [_filterBar(), _chartCard(maxY), _reportSection()],
      ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _filterButton('7 Days', ChartMode.weekly),
          const SizedBox(width: 8),
          _filterButton('Monthly', ChartMode.monthly),
          if (mode == ChartMode.monthly)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                DateFormat('MMMM yyyy').format(selectedMonth),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  Widget _filterButton(String text, ChartMode value) {
    final active = mode == value;
    return GestureDetector(
      onTap: () {
        if (value == ChartMode.monthly) {
          _showMonthPicker();
        } else {
          mode = ChartMode.weekly;
          _loadWeekly();
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.pink : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showMonthPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: 12,
        itemBuilder: (_, i) {
          final month = DateTime(DateTime.now().year, i + 1);
          return GestureDetector(
            onTap: () {
              selectedMonth = month;
              mode = ChartMode.monthly;
              _loadMonthly(month);
              Navigator.pop(context);
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(DateFormat('MMM').format(month)),
            ),
          );
        },
      ),
    );
  }

  Widget _chartCard(double maxY) {
    final barWidth = 14.0;
    final spacing = 12.0;
    final chartWidth = salesData.length * (barWidth + spacing) + 40;

    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth < MediaQuery.of(context).size.width
              ? MediaQuery.of(context).size.width
              : chartWidth,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceBetween,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 50,
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),

              /// 🔥 HAPUS TITLE ATAS & KANAN
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
                    interval: 50,
                    reservedSize: 36,
                    getTitlesWidget: (value, _) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= salesData.length) {
                        return const SizedBox.shrink();
                      }

                      final date = salesData[index].date;

                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          mode == ChartMode.weekly
                              ? DateFormat('EEE').format(date)
                              : date.day.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              barTouchData: BarTouchData(
                touchCallback: (event, response) {
                  if (response?.spot != null) {
                    setState(() {
                      selectedIndex = response!.spot!.touchedBarGroupIndex;
                    });
                  }
                },
              ),

              barGroups: List.generate(salesData.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barsSpace: spacing,
                  barRods: [
                    BarChartRodData(
                      toY: salesData[i].totalSales.toDouble(),
                      width: barWidth,
                      color: i == selectedIndex
                          ? Colors.pink
                          : Colors.pink.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _reportSection() {
    final day = salesData[selectedIndex];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Detail - ${DateFormat('dd MMM yyyy').format(day.date)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: day.products.length,
                itemBuilder: (_, i) => ListTile(title: Text(day.products[i])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesDay {
  final DateTime date;
  final int totalSales;
  final List<String> products;

  SalesDay({
    required this.date,
    required this.totalSales,
    required this.products,
  });
}
