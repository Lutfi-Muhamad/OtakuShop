import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:otakushop/models/sold_products.dart';
import 'package:otakushop/services/report_service.dart';

class TotalSalesPage extends StatefulWidget {
  const TotalSalesPage({super.key});

  @override
  State<TotalSalesPage> createState() => _TotalSalesPageState();
}

class _TotalSalesPageState extends State<TotalSalesPage> {
  String? selectedCategory;
  late Future<List<SoldProduct>> _futureSales;

  final AuthController auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _futureSales = _loadFromApi();
  }

  Future<List<SoldProduct>> _loadFromApi() async {
    debugPrint("📊 TotalSalesPage init");

    // Pastikan token & user sudah siap
    await auth.loadToken();

    if (auth.token.value.isEmpty) {
      throw Exception('TOKEN KOSONG - USER BELUM LOGIN');
    }

    final storeId = auth.user.value?.tokoId;

    if (storeId == null) {
      throw Exception('Kamu Belum Memiliki Toko');
    }

    debugPrint("🏪 storeId = $storeId");
    debugPrint("🔐 token = ${auth.token.value}");

    final data = await ReportService.fetchSales(storeId: storeId);

    debugPrint("✅ DATA RECEIVED: ${data.length}");

    return data.map((e) => SoldProduct.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF7FAF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7FAF),
        elevation: 0,
        title: Text(
          selectedCategory == null
              ? "Total Sales"
              : "Kategori: $selectedCategory",
        ),
      ),
      body: FutureBuilder<List<SoldProduct>>(
        future: _futureSales,
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
                "Belum ada produk yang terjual",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (_, i) => _productCard(products[i]),
          );
        },
      ),
    );
  }

  Widget _productCard(SoldProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.pink, size: 30),
          ),
          const SizedBox(width: 12),
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
