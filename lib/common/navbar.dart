import 'package:flutter/material.dart';

class PinkNavbar extends StatelessWidget {
  const PinkNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, color: Colors.white, size: 28),
            Row(
              children: const [
                Icon(Icons.shopping_cart, color: Colors.white),
                SizedBox(width: 20),
                Icon(Icons.person, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
