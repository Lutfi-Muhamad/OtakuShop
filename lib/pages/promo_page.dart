import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Produk Promo")),
      body: FutureBuilder<List<Product>>(
        future: ProductService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text("Tidak ada promo"));
          }

          final promos = snapshot.data!
              .where((p) => p.imageType == "wide")
              .toList();

          return ListView.builder(
            itemCount: promos.length,
            itemBuilder: (context, i) {
              final p = promos[i];
              return Container(
                margin: EdgeInsets.all(16),
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(p.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(12),
                child: Text(
                  p.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black54,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
