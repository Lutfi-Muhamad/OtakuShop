import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/product.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          // =========================
          // FOTO CAROUSEL
          // =========================
          SizedBox(
            height: 260,
            width: double.infinity,
            child: product.images.isNotEmpty
                ? CarouselSlider(
                    items: product.images.map((e) {
                      return Image.network(
                        e,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 260,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                      },
                    ),
                  )
                : const Center(
                    child: Icon(Icons.image_not_supported, size: 60),
                  ),
          ),

          const SizedBox(height: 8),

          // =========================
          // INDICATOR
          // =========================
          if (product.images.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                product.images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: activeIndex == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: activeIndex == index ? Colors.pink : Colors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE TYPE BADGE
                  _buildTag(product.imageType, Colors.red),

                  const SizedBox(height: 12),

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (product.price != null)
                    Text(
                      "IDR ${product.price}",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    "Stok: ${product.stock}",
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // ADD TO CART BUTTON
          // =========================
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Add To Cart", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
