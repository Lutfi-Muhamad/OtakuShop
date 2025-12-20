import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:otakushop/services/auth_controller.dart';
import 'package:otakushop/services/report_service.dart';

enum ChartMode { weekly, monthly }

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final auth = Get.find<AuthController>();

  ChartMode mode = ChartMode.weekly;
  DateTime? selectedMonth;
  int selectedIndex = 0;

  bool loading = false;
  String? error;

  List<SalesDay> salesData = [];

  @override
  void initState() {
    super.initState();
    debugPrint("📊 CHART PAGE OPENED");
    _loadWeekly(); // DEFAULT
  }

  // =========================
  // DATA LOADERS
  // =========================

  Future<void> _loadWeekly() async {
    try {
      loading = true;
      error = null;
      setState(() {});

      final now = DateTime.now();
      final start = now.subtract(const Duration(days: 6));

      debugPrint("📅 WEEKLY: $start → $now");

      final raw = await ReportService.fetchChartSales(
        storeId: auth.user.value!.tokoId!,
        startDate: DateFormat('yyyy-MM-dd').format(start),
        endDate: DateFormat('yyyy-MM-dd').format(now),
      );

      salesData = raw.map<SalesDay>((e) {
        return SalesDay(
          date: DateTime.parse(e['date']),
          totalSales: e['total_sold'],
          products: const [],
        );
      }).toList();

      selectedIndex = salesData.isNotEmpty ? salesData.length - 1 : 0;
    } catch (e) {
      error = e.toString();
      debugPrint("❌ LOAD WEEKLY FAILxED: $e");
    } finally {
      loading = false;
      setState(() {});
    }
  }

  Future<void> _loadMonthly(DateTime month) async {
    try {
      loading = true;
      error = null;
      setState(() {});

      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0);

      debugPrint("📅 MONTHLY: $start → $end");

      final raw = await ReportService.fetchChartSales(
        storeId: auth.user.value!.tokoId!,
        startDate: DateFormat('yyyy-MM-dd').format(start),
        endDate: DateFormat('yyyy-MM-dd').format(end),
      );

      salesData = raw.map<SalesDay>((e) {
        return SalesDay(
          date: DateTime.parse(e['date']),
          totalSales: e['total_sold'],
          products: const [],
        );
      }).toList();

      selectedIndex = salesData.isNotEmpty ? salesData.length - 1 : 0;
    } catch (e) {
      error = e.toString();
      debugPrint("❌ LOAD MONTHLY FAILED: $e");
    } finally {
      loading = false;
      setState(() {});
    }
  }

  // =========================
  // UI HELPERS
  // =========================

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
              Navigator.pop(context);
              _loadMonthly(month);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                DateFormat('MMM').format(month),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    // Hitung maxY hanya jika data ada
    double maxY = 0;
    if (salesData.isNotEmpty) {
      final maxValue = salesData
          .map((e) => e.totalSales)
          .reduce((a, b) => a > b ? a : b);
      maxY = ((maxValue / 10).ceil() * 10).toDouble();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFEEF3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF87DAF),
        title: const Text('Sales Report'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _filterBar(),

          // Gunakan Expanded agar sisa layar diisi oleh konten
          Expanded(
            child: Builder(
              builder: (context) {
                if (loading)
                  return const Center(child: CircularProgressIndicator());
                if (error != null) return Center(child: Text(error!));
                if (salesData.isEmpty)
                  return const Center(child: Text("NO SALES DATA"));

                return Column(children: [_chartCard(maxY), _reportSection()]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _filterButton('Weekly', ChartMode.weekly),
          const SizedBox(width: 8),
          _filterButton('Monthly', ChartMode.monthly),
        ],
      ),
    );
  }

  Widget _filterButton(String text, ChartMode value) {
    final active = mode == value;

    return GestureDetector(
      onTap: () {
        if (value == ChartMode.weekly) {
          mode = ChartMode.weekly;
          _loadWeekly();
        } else {
          _showMonthPicker();
        }
        setState(() {});
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

  Widget _chartCard(double maxY) {
    final barWidth = 18.0;
    final spacing = 16.0;
    final chartWidth = salesData.length * (barWidth + spacing) + 40;

    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
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
                    getTitlesWidget: (v, _) => Text(
                      v.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final i = value.toInt();
                      if (i < 0 || i >= salesData.length) {
                        return const SizedBox();
                      }
                      return Text(
                        salesData[i].date.day.toString(),
                        style: const TextStyle(fontSize: 11),
                      );
                    },
                  ),
                ),
              ),
              barGroups: List.generate(salesData.length, (i) {
                return BarChartGroupData(
                  x: i,
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
            const Text(
              'Sales Detail',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, dd MMM yyyy').format(day.date),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// MODEL
// =========================

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
