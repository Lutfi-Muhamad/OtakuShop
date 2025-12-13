import 'package:flutter/material.dart';
import 'package:otakushop/seller/seller_page.dart';
import 'package:otakushop/seller/seller_register_page.dart';
import '../services/auth_service.dart';
import '../pages/profile_edit_page.dart';

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
      final u = await AuthService.fetchUser();
      if (!mounted) return;

      setState(() {
        user = u["user"];
        loading = false;
      });
    } catch (e) {
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
      backgroundColor: const Color(0xFFF57CA1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------ TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileEditPage(userData: user!),
                          ),
                        ).then((value) {
                          _init(); // refresh profile setelah edit
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ------------------------------ GREETING
                Text(
                  "Hi! ${user?["name"] ?? "User"}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Account Information",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),

                const SizedBox(height: 10),

                // ------------------------------ ACCOUNT BOX
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: user?["photo"] != null
                            ? NetworkImage(user!["photo"])
                            : null,
                        child: user?["photo"] == null
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),

                      const SizedBox(height: 8),

                      infoItem("Nama", user?["name"]),
                      infoItem("Bio", user?["bio"] ?? "Belum ada bio"),
                      infoItem(
                        "Alamat",
                        user?["address"] ?? "Belum ada alamat",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------------------ MENU LIST
                menuButton("Belum ada toko", () {}),
                menuButton("Order History", () {}),
                menuButton("Whistlist", () {}),

                const SizedBox(height: 30),

                // ------------------------------ SELLER BUTTON
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.pink, width: 2),
                      ),
                      elevation: 4,
                    ),

                    onPressed: () {
                      if (user?["store_id"] == null) {
                        // BELUM PUNYA TOKO → Daftar
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellerRegisterPage(),
                          ),
                        );
                      } else {
                        // SUDAH PUNYA TOKO → Kelola
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SellerPage(),
                          ), // Pastikan sudah import
                        );
                      }
                    },

                    child: Text(
                      user?["store_id"] == null
                          ? "DAFTAR\nSEBAGAI SELLER"
                          : "KELOLA\nTOKO",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // WIDGET BUILDER (TARUH DI LUAR BUILD)
  // ==========================================
  Widget infoItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(value ?? "-", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget menuButton(String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Text(text, style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }
}
