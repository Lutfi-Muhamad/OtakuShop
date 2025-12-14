import 'package:flutter/material.dart';
import 'package:otakushop/services/seller_product_service.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:otakushop/seller/edit_seller_page.dart';
import 'package:otakushop/pages/home_page.dart';
import 'package:otakushop/seller/seller_profile_page.dart';
import 'add_product_page.dart';
import 'package:get/get.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  final AuthController auth = Get.find<AuthController>();
  final SellerProductService productService = SellerProductService();

  List<dynamic> myProducts = [];
  bool loading = false;
  int? lastFetchedTokoId;

  @override
  @override
  void initState() {
    super.initState();

    // 🔥 FETCH PERTAMA KALI
    final tokoId = auth.user.value?.tokoId;
    print("🚀 INIT SELLER | tokoId = $tokoId");

    if (tokoId != null) {
      lastFetchedTokoId = tokoId;
      fetchProducts(tokoId);
    }

    // 🔁 LISTEN JIKA USER BERUBAH
    ever(auth.user, (_) {
      final newTokoId = auth.user.value?.tokoId;
      print("🔁 SELLER ever() tokoId = $newTokoId");

      if (newTokoId != null && newTokoId != lastFetchedTokoId) {
        lastFetchedTokoId = newTokoId;
        fetchProducts(newTokoId);
      }
    });
  }

  Future<void> fetchProducts(int tokoId) async {
    print("📦 FETCH PRODUCTS START | tokoId = $tokoId");

    setState(() => loading = true);

    try {
      final products = await productService.getProductsByToko(tokoId);

      if (!mounted) return;

      setState(() {
        myProducts = products;
      });

      print("📦 FETCH SUCCESS | total = ${products.length}");
    } catch (e) {
      print("❌ FETCH ERROR: $e");
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
      print("📦 FETCH END | loading = false");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final tokoId = auth.user.value?.tokoId;

          print("🛒 SELLER BUILD | tokoId = $tokoId");

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TOP NAVBAR =================
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.pinkAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.black, size: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ================= BACK + SEARCH =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.pinkAccent,
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Text(
                    "My Products",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                // ================= STATE HANDLING =================

                // LOADING
                if (loading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.pinkAccent),
                  ),

                // BELUM PUNYA TOKO
                if (!loading && tokoId == null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          const Text(
                            "Kamu belum terdaftar sebagai seller",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "toko_id kamu = $tokoId",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),

                // TOKO ADA, PRODUK KOSONG
                if (!loading && tokoId != null && myProducts.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "Belum ada barang yang dijual",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // GRID PRODUK
                if (!loading && myProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                      children: List.generate(myProducts.length, (i) {
                        final p = myProducts[i];
                        return productCard(
                          context,
                          p["name"] ?? "",
                          "IDR ${p['price']}",
                          p["images"] != null && p["images"].isNotEmpty
                              ? p["images"][0]
                              : "https://via.placeholder.com/150",
                        );
                      }),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }

  // ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
  //                 PRODUCT CARD
  // ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

  Widget productCard(
  BuildContext context,
  String title,
  String price,
  String imgUrl,
) {
  return SizedBox(
    height: 260, // ⬅️ WAJIB: constraint untuk GridView
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ================= IMAGE =================
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imgUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),

        const SizedBox(height: 6),

        // ================= ACTION ROW =================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Limited",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(width: 6),

            // EDIT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditSellerPage()),
                );
              },
              child: const Icon(Icons.edit, size: 18, color: Colors.blue),
            ),

            const SizedBox(width: 8),

            // DELETE
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Yakin ingin menghapus?\nTindakan ini tidak bisa dibatalkan",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.green,
                                  child: const Center(
                                    child: Text(
                                      "BATAL",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  // delete logic nanti
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  color: Colors.red,
                                  child: const Center(
                                    child: Text(
                                      "IYA",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.delete, size: 18, color: Colors.red),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // ================= TITLE =================
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 6),

        // ================= PRICE =================
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
}