import 'package:flutter/material.dart';
import 'cart_page.dart';
import '../services/auth_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic>? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final u = await AuthService.fetchUser(); // CALL /user
      if (!mounted) return;

      setState(() {
        user = u;
        loading = false;
      });
    } catch (e) {
      // Anggap semua error auth = not logged in
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),

            const SizedBox(height: 12),

            Text(
              user?["name"] ?? "Unknown User",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),
            Text(user?["bio"] ?? "Bio masih kosong"),
            Text(user?["address"] ?? "Alamat belum diisi"),

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
              leading: const Icon(Icons.receipt_long),
              title: const Text("Etalase Saya"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await AuthService.logout();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
