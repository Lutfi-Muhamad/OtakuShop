import 'package:flutter/material.dart';
import 'package:otakushop/models/sold_products.dart';

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
    _futureSales = _loadDummyData();
  }

  /// DUMMY DATA (UI ONLY)
  Future<List<SoldProduct>> _loadDummyData() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      SoldProduct(
        name: "Nendoroid Gojo Satoru",
        category: "Figure",
        image: "",
        sold: 120,
      ),
      SoldProduct(
        name: "One Piece Luffy Gear 5",
        category: "Figure",
        image: "",
        sold: 95,
      ),
      SoldProduct(
        name: "Naruto Hoodie",
        category: "Apparel",
        image: "",
        sold: 60,
      ),
    ];
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
            return const Center(
              child: Text(
                "Terjadi kesalahan",
                style: TextStyle(color: Colors.white),
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

  /// CARD PRODUK (TANPA IMAGE)
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

  /// DUMMY PILIH KATEGORI
  void _selectCategory() {
    setState(() {
      selectedCategory = selectedCategory == null ? "Figure" : null;
    });
  }
}
