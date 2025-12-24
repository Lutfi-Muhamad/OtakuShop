import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_controller.dart';
import '../seller/seller_page.dart';
import '../seller/seller_register_page.dart';
import '../pages/profile_edit_page.dart';
import '../pages/order_history_page.dart';
import '../pages/wishlist_page.dart';

class UserPage extends StatelessWidget {
  UserPage({super.key});

  final AuthController auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ⬅️ BELUM LOGIN → LANGSUNG KE LOGIN PAGE
      print("👤 USER PAGE | tokoId = ${auth.user.value?.tokoId}");

      final user = auth.user.value;
      if (user == null) {
        Future.microtask(() {
          Get.offAllNamed('/login');
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).scaffoldBackgroundColor
            : const Color(0xFFF57CA1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () async {
                          await Get.to(() => ProfileEditPage(user: user));
                          await auth.refreshUser();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ---------------- GREETING
                  Text(
                    "Hi! ${user.name}",
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

                  // ---------------- ACCOUNT BOX
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.photo != null
                              ? NetworkImage(user.photo!)
                              : null,
                          child: user.photo == null
                              ? const Icon(Icons.person, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        infoItem("Nama", user.name),
                        infoItem("Bio", user.bio ?? "Belum ada bio"),
                        infoItem("Alamat", user.address ?? "Belum ada alamat"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- MENU
                  menuButton(
                    context,
                    user.tokoId == null ? "Belum ada toko" : "Toko saya",
                    () async {
                      await auth.refreshUser();
                      if (auth.user.value?.tokoId == null) {
                        Get.to(() => const SellerRegisterPage());
                      } else {
                        Get.to(() => const SellerPage());
                      }
                    },
                  ),
                  menuButton(context, "Order History", () {
                    Get.to(() => const OrderHistoryPage());
                  }),
                  menuButton(context, "Wishlist", () {
                    Get.to(() => const WishlistPage());
                  }),
                  menuButton(context, "Logout", () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Apakah kamu yakin ingin logout?"),
                        actions: [
                          TextButton(
                            onPressed: Get.back,
                            child: const Text("Batal"),
                          ),
                          TextButton(
                            onPressed: () async {
                              await auth.logout();
                              Get.offAllNamed('/login');
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  // ---------------- SELLER BUTTON
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
                      ),
                      onPressed: () async {
                        await auth.refreshUser(); // ⬅️ TUNGGU SAMPAI SELESAI

                        final tokoId = auth.user.value?.tokoId;
                        print("➡️ NAVIGATE TO SELLER | tokoId = $tokoId");

                        if (tokoId == null) {
                          Get.to(() => const SellerRegisterPage());
                        } else {
                          Get.to(() => const SellerPage());
                        }
                      },
                      child: Text(
                        user.tokoId == null
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
    });
  }

  // ================= WIDGET HELPERS =================

  Widget infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget menuButton(BuildContext context, String text, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: double.infinity,
      child: Material(
        color: Theme.of(context).cardColor,
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
