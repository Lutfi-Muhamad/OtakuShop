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

  String selectedFilter = 'all'; // all | category
  String? selectedCategory;

  late Future<List<SoldProduct>> _futureBestSales;

  @override
  void initState() {
    super.initState();
    _futureBestSales = _loadBestSales();
  }

  Future<List<SoldProduct>> _loadBestSales() async {
    await auth.loadToken();

    if (auth.token.value.isEmpty) {
      throw Exception('TOKEN KOSONG');
    }

    final storeId = auth.user.value?.tokoId;
    if (storeId == null) {
      throw Exception('STORE ID TIDAK ADA');
    }

    final data = await ReportService.fetchBestSales(
      storeId: storeId,
      category: selectedFilter == 'category' ? selectedCategory : null,
    );

    return data.map((e) => SoldProduct.fromJson(e)).toList();
  }

  void _applyFilter({required String filter, String? category}) {
    setState(() {
      selectedFilter = filter;
      selectedCategory = category;
      _futureBestSales = _loadBestSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7FAF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7FAF),
        elevation: 0,
        title: const Text('Best Sales'),
      ),
      body: Column(
        children: [
          _filterBar(),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: selectedFilter == 'all',
            onSelected: (_) => _applyFilter(filter: 'all'),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Figure'),
            selected:
                selectedFilter == 'category' && selectedCategory == 'Figure',
            onSelected: (_) =>
                _applyFilter(filter: 'category', category: 'Figure'),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Apparel'),
            selected:
                selectedFilter == 'category' && selectedCategory == 'Apparel',
            onSelected: (_) =>
                _applyFilter(filter: 'category', category: 'Apparel'),
          ),
        ],
      ),
    );
  }

  Widget _content() {
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
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada data best seller',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final products = snapshot.data!;
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.pink, size: 32),
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
                Text(product.category),
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
