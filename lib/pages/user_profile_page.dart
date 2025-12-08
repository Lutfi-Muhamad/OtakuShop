import 'package:flutter/material.dart';
import 'cart_page.dart';
import '../services/auth_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
            ),

            const SizedBox(height: 12),

            const Text(
              "Lutfi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),
            const Text("Bio masih kosong"),
            const Text("Alamat belum diisi"),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Keranjang Saya"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("History Belanja"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await AuthService.logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
