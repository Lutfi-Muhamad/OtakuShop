import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:otakushop/models/sold_products.dart';
import 'package:otakushop/services/report_service.dart';

class BestSalesPage extends StatefulWidget {
  const BestSalesPage({super.key});

  @override
  State<BestSalesPage> createState() => _BestSalesPageState();
}

class _BestSalesPageState extends State<BestSalesPage> {
  final AuthController auth = Get.find<AuthController>();

  // ===== FILTER STATE =====
  String? selectedOrder; // 'top' | 'bottom'
  String? selectedCategory; // 'nendroid' | 'bags' | 'figure'
  String? selectedSeries; // 'onepiece' | 'jjk'

  Future<List<SoldProduct>>? _futureBestSales;

  @override
  void initState() {
    super.initState();
    _futureBestSales = _loadBestSales();
  }

  Future<List<SoldProduct>> _loadBestSales() async {
    await auth.loadToken();

    if (auth.token.value.isEmpty) {
      return [];
    }

    final storeId = auth.user.value?.tokoId;
    if (storeId == null) {
      return [];
    }

    final data = await ReportService.fetchProductSales(
      storeId: storeId,
      order: selectedOrder,
      category: selectedCategory,
      series: selectedSeries,
    );

    return data.map((e) => SoldProduct.fromJson(e)).toList();
  }

  void _applyFilter({String? order, String? category, String? series}) {
    setState(() {
      if (order != null) selectedOrder = order;
      if (category != null) selectedCategory = category;
      if (series != null) selectedSeries = series;

      // reload data
      _futureBestSales = _loadBestSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFFF7FAF),
      appBar: AppBar(
        backgroundColor: isDark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color(0xFFFF7FAF),
        elevation: 0,
        title: const Text('Best Sales'),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        titleTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          _filterBar(),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  // ================= FILTER UI =================

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Teratas'),
                selected: selectedOrder == 'top',
                onSelected: (_) => _applyFilter(order: 'top'),
              ),
              ChoiceChip(
                label: const Text('Terendah'),
                selected: selectedOrder == 'bottom',
                onSelected: (_) => _applyFilter(order: 'bottom'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Nendroid'),
                selected: selectedCategory == 'nendroid',
                onSelected: (_) => _applyFilter(category: 'nendroid'),
              ),
              ChoiceChip(
                label: const Text('Bags'),
                selected: selectedCategory == 'bags',
                onSelected: (_) => _applyFilter(category: 'bags'),
              ),
              ChoiceChip(
                label: const Text('Figure'),
                selected: selectedCategory == 'figure',
                onSelected: (_) => _applyFilter(category: 'figure'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('One Piece'),
                selected: selectedSeries == 'onepiece',
                onSelected: (_) => _applyFilter(series: 'onepiece'),
              ),
              ChoiceChip(
                label: const Text('JJK'),
                selected: selectedSeries == 'jjk',
                onSelected: (_) => _applyFilter(series: 'jjk'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= CONTENT =================

  Widget _content() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_futureBestSales == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<SoldProduct>>(
      future: _futureBestSales,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              snapshot.error.toString(),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          );
        }

        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return const Center(
            child: Text('Belum ada data penjualan', style: TextStyle()),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: products.length,
          itemBuilder: (_, i) =>
              _bestSellerCard(product: products[i], rank: i + 1),
        );
      },
    );
  }

  Widget _bestSellerCard({required SoldProduct product, required int rank}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$rank",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.pink),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('${product.category} • ${product.series}'),
                const SizedBox(height: 4),
                Text("Terjual x${product.sold}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
