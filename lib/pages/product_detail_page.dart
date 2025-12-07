import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final String title;
  final String price;

  const ProductDetailPage({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int currentImage = 0;

  final List<String> productImages = [
    "https://via.placeholder.com/400x400",
    "https://via.placeholder.com/400x400",
    "https://via.placeholder.com/400x400",
    "https://via.placeholder.com/400x400",
    "https://via.placeholder.com/400x400",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[300],
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.shopping_cart_outlined, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.person_outline, color: Colors.black),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IMAGE CAROUSEL
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      itemCount: productImages.length,
                      onPageChanged: (index) {
                        setState(() => currentImage = index);
                      },
                      itemBuilder: (_, i) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            productImages[i],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),

                  // LEFT BUTTON
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),

                  // RIGHT BUTTON
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // DOT INDICATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  productImages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: currentImage == index
                          ? Colors.pink
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // LABELS
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Series",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Limited",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // TITLE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Gojo Satoru - Jujutsu Kaisen",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "By Imaginary Company",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // PRICE
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "IDR 500.000",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // BUTTONS
              Row(
                children: [
                  // SHARE
                  Container(
                    width: 60,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.share, color: Colors.pink),
                  ),
                  const SizedBox(width: 10),

                  // LIKE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.pink),
                        SizedBox(width: 6),
                        Text("619"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // ADD TO CART
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.pink[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Add To Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
