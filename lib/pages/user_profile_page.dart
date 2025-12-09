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

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _loadUser();
  }

  void _checkAuth() async {
    final hasToken = await AuthService.hasToken();

    if (!hasToken && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _loadUser() async {
    final u = await AuthService.getUser();
    if (mounted) {
      setState(() {
        user = u;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    user!["name"] ?? "Unknown User",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(user!["bio"] ?? "Bio masih kosong"),
                  Text(user!["address"] ?? "Alamat belum diisi"),

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
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
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
