import 'package:flutter/material.dart';
import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/services/seller_product_service.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:otakushop/seller/edit_seller_page.dart';
import 'add_product_page.dart';
import 'package:get/get.dart';

class SellerController extends GetxController {
  final AuthController auth = Get.find<AuthController>();
  final SellerProductService productService = SellerProductService();

  var myProducts = <dynamic>[].obs;
  var loading = false.obs;
  int? lastFetchedTokoId;

  @override
  void onInit() {
    super.onInit();
    _initLoad();
  }

  void _initLoad() {
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

    loading.value = true;

    try {
      final products = await productService.getProductsByToko(tokoId);
      myProducts.assignAll(products);
      print("📦 FETCH SUCCESS | total = ${products.length}");
    } catch (e) {
      print("❌ FETCH ERROR: $e");
    } finally {
      loading.value = false;
      print("📦 FETCH END | loading = false");
    }
  }

  Future<void> deleteProduct(int productId) async {
    try {
      final result = await productService.deleteProduct(productId);
      if (result) {
        myProducts.removeWhere((p) => p["id"] == productId);
        Get.snackbar(
          "Sukses",
          "Produk berhasil dihapus",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerController());
    final auth = Get.find<AuthController>();

    return Scaffold(
      drawer: const AppDrawer(),
      //backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          final tokoId = auth.user.value?.tokoId;
          final loading = controller.loading.value;
          final myProducts = controller.myProducts;

          print("🛒 SELLER BUILD | tokoId = $tokoId");

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= TOP NAVBAR =================
                const PinkNavbar(),

                const SizedBox(height: 10),

                // ================= BACK + SEARCH =================
                const SearchBarWidget(),

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
                if (loading && myProducts.isEmpty)
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
                          controller,
                          context,
                          p["name"] ?? "",
                          "IDR ${p['price']}",
                          p["images"] != null && p["images"].isNotEmpty
                              ? p["images"][0]
                              : "",
                          p["id"],
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
        onPressed: () async {
          // Menggunakan Get.to dan menunggu result
          final result = await Get.to(() => const AddProductPage());

          if (result == true && auth.user.value?.tokoId != null) {
            controller.fetchProducts(auth.user.value!.tokoId!);
          }
        },
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }

  // ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
  //                 PRODUCT CARD
  // ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬

  Widget productCard(
    SellerController controller,
    BuildContext context,
    String title,
    String price,
    String imgUrl,
    int productId,
  ) {
    final auth = Get.find<AuthController>();
    return SizedBox(
      height: 260, // ⬅️ WAJIB: constraint untuk GridView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ================= IMAGE =================
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imgUrl.isNotEmpty
                ? Image.network(
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
                  )
                : Container(
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),

          const SizedBox(height: 6),

          // ================= ACTION ROW =================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
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
                onTap: () async {
                  debugPrint("🟦 [SELLER PAGE]");
                  debugPrint("✏️ EDIT ICON CLICKED");
                  debugPrint("📦 productId = $productId");
                  debugPrint("🏪 tokoId = ${auth.user.value?.tokoId}");

                  final result = await Get.to(
                    () => EditSellerPage(
                      productId: productId,
                      storeId: auth.user.value!.tokoId!,
                    ),
                  );

                  // 🔥 REFRESH JIKA BERHASIL EDIT
                  if (result == true && auth.user.value?.tokoId != null) {
                    controller.fetchProducts(auth.user.value!.tokoId!);
                  }
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
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
                                    controller.deleteProduct(productId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
