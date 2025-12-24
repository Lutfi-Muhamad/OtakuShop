import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_controller.dart';
import 'package:get/get.dart';
import '../services/cart_service.dart';
import '../pages/home_page.dart'; // Import HomeController

class CartPageLogicController extends GetxController {
  static String get baseUrl => AuthController.baseUrl;
  final auth = Get.find<AuthController>();
  var carts = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuth();
  }

  void checkAuth() {
    if (auth.token.value.isEmpty) {
      // Get.offAllNamed('/login')
    } else {
      fetchCart();
    }
  }

  // =========================
  // GET CART FROM API
  // =========================
  Future<void> fetchCart() async {
    isLoading.value = true;

    final res = await http.get(
      Uri.parse("$baseUrl/cart"),
      headers: auth.headers(json: false),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      carts.assignAll(data['carts'] ?? []);
      isLoading.value = false;
    } else if (res.statusCode == 401) {
      await auth.logout();
      Get.offAllNamed('/login');
    } else {
      isLoading.value = false;
    }
  }

  // =========================
  // UPDATE QTY
  // =========================
  Future<void> updateQty(int cartId, int qty) async {
    await http.put(
      Uri.parse("$baseUrl/cart/$cartId"),
      headers: auth.headers(),
      body: jsonEncode({"qty": qty}),
    );

    fetchCart();
  }

  // =========================
  // DELETE CART
  // =========================
  Future<void> deleteCart(int cartId) async {
    await http.delete(
      Uri.parse("$baseUrl/cart/$cartId"),
      headers: auth.headers(json: false),
    );

    fetchCart();
    // Update notifikasi navbar
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().fetchCartCount();
    }
  }

  // =========================
  // CHECKOUT
  // =========================
  Future<void> checkout() async {
    final res = await http.post(
      Uri.parse("$baseUrl/cart/checkout"),
      headers: auth.headers(json: false),
    );

    debugPrint("🧾 CHECKOUT STATUS: ${res.statusCode}");
    debugPrint("🧾 RESPONSE: ${res.body}");

    if (res.statusCode == 200) {
      fetchCart();

      // Update notifikasi navbar (jadi 0)
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().fetchCartCount();
      }

      // 🔥 REFRESH STOK DI HOME & REDIRECT
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchProducts();
      }

      Get.snackbar(
        "Sukses",
        "Checkout sukses",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/'); // Kembali ke Home
    } else {
      Get.snackbar(
        "Gagal",
        jsonDecode(res.body)['message'] ?? "Terjadi kesalahan",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartPageLogicController());

    return Scaffold(
      appBar: AppBar(title: const Text("Kersanjang")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.carts.isEmpty) {
          return const Center(child: Text("Keranjang kosong"));
        }

        int total = 0;
        for (var cart in controller.carts) {
          final price = cart['product']['price'] ?? 0;
          final qty = cart['qty'] ?? 0;
          total += (price as int) * (qty as int);
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: controller.carts.length,
                  itemBuilder: (context, index) {
                    final cart = controller.carts[index];
                    final product = cart['product'];

                    return Card(
                      color: Theme.of(context).cardColor,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // ✅ AMAN: PAKAI product['image']
                            Image.network(
                              product['image'],
                              width: 80,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.broken_image, size: 50),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Rp ${product['price']}"),

                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          if (cart['qty'] > 1) {
                                            controller.updateQty(
                                              cart['id'],
                                              cart['qty'] - 1,
                                            );
                                          }
                                        },
                                      ),
                                      Text(cart['qty'].toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          controller.updateQty(
                                            cart['id'],
                                            cart['qty'] + 1,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          controller.deleteCart(cart['id']);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // =========================
              // TOTAL & CHECKOUT
              // =========================
              Text(
                "Total: Rp $total",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.checkout,
                  child: const Text("Checkout"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
