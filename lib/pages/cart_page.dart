import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List carts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  // =========================
  // GET CART FROM API
  // =========================
  Future<void> fetchCart() async {
    final token = await AuthService.getToken();

    final res = await http.get(
      Uri.parse(
        "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api/cart",
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = json.decode(res.body);

    setState(() {
      carts = data['carts'] ?? [];
      isLoading = false;
    });
  }

  // =========================
  // UPDATE QTY
  // =========================
  Future<void> updateQty(int cartId, int qty) async {
    final token = await AuthService.getToken();

    await http.put(
      Uri.parse(
        "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api/cart/$cartId",
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {"qty": qty.toString()},
    );

    fetchCart();
  }

  // =========================
  // DELETE CART
  // =========================
  Future<void> deleteCart(int cartId) async {
    final token = await AuthService.getToken();

    await http.delete(
      Uri.parse(
        "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api/cart/$cartId",
      ),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    int total = 0;

    for (var cart in carts) {
      final price = cart['product']['price'] ?? 0;
      final qty = cart['qty'] ?? 0;
      total += (price as int) * (qty as int);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : carts.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final cart = carts[index];
                        final product = cart['product'];

                        return Card(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                updateQty(
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
                                              updateQty(
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
                                              deleteCart(cart['id']);
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("✅ Checkout sukses")),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
