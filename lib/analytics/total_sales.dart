import 'package:flutter/material.dart';
import 'package:otakushop/models/sold_products.dart';
// import 'package:otakushop/services/seller_product_service.dart';

class TotalSalesPage extends StatefulWidget {
  const TotalSalesPage({super.key});

  @override
  State<TotalSalesPage> createState() => _TotalSalesPageState();
}

class _TotalSalesPageState extends State<TotalSalesPage> {
  String? selectedCategory;
  late Future<List<SoldProduct>> _futureSales;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
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
        actions: [
          TextButton(
            onPressed: () {
            },
            child: const Text(
              "Pilih Kategori",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<SoldProduct>>(
        future: _futureSales,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Gagal mengambil data",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada produk yang terjual",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (_, i) =>
                _productCard(products[i]),
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
          Image.network(
            product.image,
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
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