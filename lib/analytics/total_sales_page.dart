import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_controller.dart';
import '../models/sold_products.dart';
import '../services/report_service.dart';

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

    final data = await ReportService.fetchProductSales(storeId: storeId);

    debugPrint("✅ DATA RECEIVED: ${data.length}");

    return data.map((e) => SoldProduct.fromJson(e)).toList();
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
        title: Text(
          selectedCategory == null
              ? "Total Sales"
              : "Kategori: $selectedCategory",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
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
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Belum ada produk yang terjual", style: TextStyle()),
            );
          }

          final products = snapshot.data!;

          // 🔥 HITUNG GRAND TOTAL
          int grandTotal = 0;
          for (var p in products) {
            grandTotal += p.revenue;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (_, i) => _productCard(products[i]),
                ),
              ),
              // 🔥 TOTAL PENDAPATAN DI BAWAH
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Pendapatan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "IDR $grandTotal",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _productCard(SoldProduct product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final harga = product.sold > 0 ? product.revenue ~/ product.sold : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Colors.pink.shade50,
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
                Text("${product.category} • IDR $harga"),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Terjual x${product.sold}"),
                    Text(
                      "Total: IDR ${product.revenue}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
