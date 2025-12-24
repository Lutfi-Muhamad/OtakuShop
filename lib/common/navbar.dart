import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../seller/user_profile_page.dart';
import '../services/cart_service.dart';
import '../services/auth_controller.dart';
import '../seller/seller_page.dart';
import '../pages/cart_page.dart';

class PinkNavbar extends StatelessWidget implements PreferredSizeWidget {
  const PinkNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final auth = Get.find<AuthController>();

    return Container(
      height: 60,
      color: Colors.pink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Get.offAllNamed('/');
            },
          ),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartPage()),
                      ).then((_) => cartController.fetchCartCount());
                    },
                  ),
                  Obx(
                    () => cartController.totalItems.value > 0
                        ? Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${cartController.totalItems.value}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserPage()),
                  );
                },
              ),

              // 🔥 ICON SELLER (Hanya jika punya toko)
              Obx(() {
                if (auth.user.value?.tokoId != null) {
                  return IconButton(
                    icon: const Icon(Icons.store, color: Colors.white),
                    onPressed: () {
                      Get.to(() => const SellerPage());
                    },
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}
