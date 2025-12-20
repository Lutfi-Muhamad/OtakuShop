import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/common/footer.dart.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/common/product_grid.dart';
import 'package:otakushop/pages/promo_page.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var searchQuery = "".obs;
  var errorMessage = "".obs;
  var selectedCategory = "All".obs; // 🔥 State untuk kategori

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";
      var products = await ProductService.fetchProducts();
      productList.assignAll(products);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> get filteredProducts {
    var list = productList.toList();

    // 1. Filter Category
    if (selectedCategory.value != "All") {
      list = list
          .where(
            (p) =>
                p.category.toLowerCase() ==
                selectedCategory.value.toLowerCase(),
          )
          .toList();
    }

    // 2. Filter Search
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    return list;
  }

  void selectCategory(String category) => selectedCategory.value = category;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      drawer: const AppDrawer(), // ← WAJIB di Scaffold utama
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 🔥 TAMBAHKAN INI: Cek Error sebelum Cek Data Kosong
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Terjadi Kesalahan:\n${controller.errorMessage.value}",
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text("Tidak ada"));
        }

        // 🔥 LOGIC SEARCH FILTER
        final products = controller.filteredProducts;

        final squares = products.where((p) => p.imageType == "square").toList();
        final wides = products.where((p) => p.imageType == "wide").toList();

        // 🔥 WRAP DENGAN REFRESH INDICATOR
        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchProducts();
          },
          child: CustomScrollView(
            slivers: [
              // ================= SLIVER APP BAR =================
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.pink,
                toolbarHeight: 60,

                // ❌ JANGAN FlexibleSpaceBar background
                // ✅ TARUH NAVBAR DI title
                title: const PinkNavbar(),

                automaticallyImplyLeading: false,
              ),

              // ================= CONTENT =================
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SearchBarWidget(
                      onChanged: (value) =>
                          controller.searchQuery.value = value,
                    ),

                    const SizedBox(height: 20),

                    // PROMO BANNER
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PromoPage()),
                        );
                      },
                      child: _buildBannerPromo(),
                    ),

                    const SizedBox(height: 20),
                    _buildCategories(controller), // 🔥 Pass controller
                    const SizedBox(height: 10),
                    _buildFilters(),
                    const SizedBox(height: 20),

                    // GRID PRODUK (SQUARE)
                    ProductGrid(products: squares),

                    const SizedBox(height: 30),

                    // TRENDING (WIDE)
                    if (wides.isNotEmpty) _buildTrending(wides.first),

                    const SizedBox(height: 20),

                    // LIST BAWAH
                    ProductGrid(products: squares),

                    const SizedBox(height: 50),
                    _buildSeriesButton(),
                    const SizedBox(height: 50),
                    const FooterWidget(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ==================== PROMO ====================
  Widget _buildBannerPromo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          "Luffy 50% Off",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==================== CATEGORIES ====================
  Widget _buildCategories(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _categoryItem(controller, Icons.apps, "All", "All"),
        _categoryItem(controller, Icons.toys, "Nendoroid", "nendoroid"),
        _categoryItem(controller, Icons.backpack, "Backpack", "bags"),
        _categoryItem(controller, Icons.star, "Figure", "figure"),
      ],
    );
  }

  Widget _categoryItem(
    HomeController controller,
    IconData icon,
    String label,
    String value,
  ) {
    final isSelected = controller.selectedCategory.value == value;
    return GestureDetector(
      onTap: () => controller.selectCategory(value),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: isSelected ? Colors.pink : Colors.grey.shade200,
            child: Icon(
              icon,
              size: 30,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.pink : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.filter_list),
          SizedBox(width: 5),
          Text("Filters"),
        ],
      ),
    );
  }

  // ==================== TRENDING (WIDE) ====================
  Widget _buildTrending(Product p) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "Trending",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () {
            // jika mau klik trending -> promo juga bisa
          },
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade300,
                image: p.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(p.images.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: p.images.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text("Series", style: TextStyle(color: Colors.white)),
    );
  }
}
