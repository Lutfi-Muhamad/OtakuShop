import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/auth_controller.dart'; // Import AuthController untuk helper image
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
              // 🔥 SAFETY CHECK: Pastikan ada gambar
              final hasImage = p.images.isNotEmpty;
              final imageUrl = hasImage
                  ? AuthController.getImageUrl(p.images.first)
                  : '';

              return Container(
                margin: EdgeInsets.all(16),
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  image: hasImage
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
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
