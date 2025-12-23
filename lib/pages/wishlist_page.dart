import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/wishlist_controller.dart';
import '../pages/product_detail_page.dart';
import '../services/auth_controller.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishlistController());

    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: Obx(() {
        if (controller.wishlist.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text("Wishlist kamu masih kosong"),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.wishlist.length,
          itemBuilder: (context, index) {
            final product = controller.wishlist[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: product.images.isNotEmpty
                    ? Image.network(
                        AuthController.getImageUrl(product.images.first),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
                      )
                    : const Icon(Icons.image_not_supported),
                title: Text(product.name),
                subtitle: Text("IDR ${product.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.toggleWishlist(product),
                ),
                onTap: () => Get.to(() => ProductDetailPage(product: product)),
              ),
            );
          },
        );
      }),
    );
  }
}
