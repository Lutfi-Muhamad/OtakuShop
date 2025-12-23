import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../pages/login_page.dart';
import '../services/cart_service.dart';
import '../services/auth_controller.dart';
import '../models/product.dart';
import '../services/wishlist_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int activeIndex = 0;
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final wishlistController = Get.put(WishlistController());

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          Obx(() {
            final isWishlisted = wishlistController.isWishlisted(product.id);
            return IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.pink : Colors.black,
              ),
              onPressed: () => wishlistController.toggleWishlist(product),
            );
          }),
        ],
      ),
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
                        AuthController.getImageUrl(e),
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

                  // =========================
                  // INFO TOKO
                  // =========================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: Colors.pink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.storeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (product.storeAddress.isNotEmpty)
                                Text(
                                  product.storeAddress,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

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
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                // QUANTITY SELECTOR
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.pink),
                        onPressed: () {
                          if (qty > 1) setState(() => qty--);
                        },
                      ),
                      Text(
                        "$qty",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.pink),
                        onPressed: () {
                          if (qty < product.stock) setState(() => qty++);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // ADD TO CART BUTTON
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      final auth = Get.find<AuthController>();

                      if (auth.token.value.isEmpty) {
                        Get.snackbar(
                          "Akses Ditolak",
                          "Silakan login terlebih dahulu",
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                        return;
                      }

                      final success = await CartService.addToCart(
                        product.id,
                        product.storeId,
                        qty: qty,
                      );

                      if (success) {
                        Get.snackbar(
                          "Sukses",
                          "Berhasil ditambahkan ke cart",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(15),
                        );
                        Get.offAllNamed('/');
                      } else {
                        Get.snackbar(
                          "Gagal",
                          "Gagal menambahkan ke keranjang",
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(15),
                        );
                      }
                    },
                    child: const Text(
                      "Add To Cart",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
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
