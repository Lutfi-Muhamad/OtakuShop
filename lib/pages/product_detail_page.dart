import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                Text(
                  "Harga: IDR ${product.price}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),

                SizedBox(height: 8),

                Text("Stok: ${product.stock}", style: TextStyle(fontSize: 14)),

                SizedBox(height: 12),

                Text(product.description, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
