import 'package:flutter/material.dart';
import 'package:otakushop/seller/user_profile_page.dart';
import '../pages/cart_page.dart';



class PinkNavbar extends StatelessWidget {
  const PinkNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        color: Colors.pink,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // =======================
            // MENU ICON
            // =======================
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menu ditekan")),
                );
              },
              child: const Icon(Icons.menu, color: Colors.white, size: 28),
            ),

            // =======================
            // CART + PROFILE
            // =======================
            Row(
              children: [
                // ===== CART =====
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CartPage(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 20),

                // ===== PROFILE =====
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserPage(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
