import 'package:flutter/material.dart';
// import 'cart_page.dart';
import '../services/auth_service.dart';
import 'profile_edit_page.dart';

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
        user = u["user"]; // AMBIL ISI DALAM "user"
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
      backgroundColor: const Color(0xFFF57CA1), // PINK BACKGROUND
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
                    // BACK BUTTON
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // EDIT BUTTON
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
                      // FOTO PROFIL
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
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD6E2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Text(
                      "TOMBOL\nSELER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // ------------------------------ ILLUSTRATION BOX
                // Center(
                //   child: Image.asset(
                //     "assets/chest.png", // sesuaikan asset kamu
                //     width: 140,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET ITEM INFORMASI
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

  // WIDGET MENU LIST
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
