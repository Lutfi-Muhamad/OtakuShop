import 'package:flutter/material.dart';
import 'package:otakushop/models/sold_products.dart';

class BestSellerPage extends StatefulWidget {
  const BestSellerPage({super.key});

  @override
  State<BestSellerPage> createState() => _BestSellerPageState();
}

class _BestSellerPageState extends State<BestSellerPage> {
  late Future<List<SoldProduct>> _futureBestSeller;

  @override
  void initState() {
    super.initState();
    _futureBestSeller = _loadDummyData();
  }

  Future<List<SoldProduct>> _loadDummyData() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      SoldProduct(name: "Nendoroid Gojo Satoru", category: "Figure", sold: 120),
      SoldProduct(name: "One Piece Luffy Gear 5", category: "Figure", sold: 95),
      SoldProduct(
        name: "Naruto Shippuden Hoodie",
        category: "Apparel",
        sold: 80,
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
        title: const Text("Best Seller Item"),
      ),
      body: FutureBuilder<List<SoldProduct>>(
        future: _futureBestSeller,
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
                "Belum ada produk terjual",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final products = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (_, index) {
              return _bestSellerCard(product: products[index], rank: index + 1);
            },
          );
        },
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                "Best Seller Item",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
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
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.pink,
                  size: 32,
                ),
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
        ],
      ),
    );
  }
}
