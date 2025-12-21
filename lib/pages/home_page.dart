import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/common/footer.dart.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/common/product_grid.dart';
import 'package:otakushop/pages/promo_page.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var searchQuery = "".obs;
  var errorMessage = "".obs;
  var selectedCategory = "All".obs;
  var selectedSeries = "All".obs;
  var sortPrice = "none".obs;
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

    // 2. Filter Series
    if (selectedSeries.value != "All") {
      list = list
          .where(
            (p) => p.series.toLowerCase() == selectedSeries.value.toLowerCase(),
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

    // 3. Sort Price
    if (sortPrice.value == 'asc') {
      list.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
    } else if (sortPrice.value == 'desc') {
      list.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
    }

    return list;
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void selectSeries(String series) => selectedSeries.value = series;
  void setSortPrice(String sort) => sortPrice.value = sort;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      drawer: const AppDrawer(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
        // 🔥 Pisahkan produk berdasarkan imageType promo
        final promos =
            products
                .where((p) => p.imageType == "promo" && p.images.isNotEmpty)
                .toList()
              ..sort((a, b) => b.id.compareTo(a.id));

        final squares = products.where((p) => p.imageType == "square").toList();

        // 🔥 Sort Wides (Trending) by ID Descending (Newest First)
        final wides = products.where((p) => p.imageType == "wide").toList()
          ..sort((a, b) => b.id.compareTo(a.id));

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
                    if (promos.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PromoPage()),
                          );
                        },
                        child: _buildBannerPromo(promos.first),
                      ),

                    const SizedBox(height: 20),
                    _buildCategories(controller),
                    const SizedBox(height: 10),
                    _buildFilters(
                      context,
                      controller,
                    ), // 🔥 Pass context & controller
                    const SizedBox(height: 20),

                    // GRID PRODUK (SQUARE)
                    ProductGrid(products: squares),

                    // 🔥 SEPARATOR SEBELUM TRENDING
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Divider(thickness: 1.5),
                    ),

                    // TRENDING (WIDE)
                    if (wides.isNotEmpty) _buildTrending(wides.first),

                    // 🔥 SEPARATOR SETELAH TRENDING
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: Divider(thickness: 1.5),
                    ),

                    // LIST BAWAH (Jika masih diperlukan, jika tidak bisa dihapus)
                    ProductGrid(products: squares),

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
  Widget _buildBannerPromo(Product promo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: promo.ratioDouble, // 16:9 dari backend
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
          ),
          items: promo.images.map((url) {
            return Image.network(
              url,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (c, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) =>
                  const Center(child: Icon(Icons.broken_image)),
            );
          }).toList(),
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

  Widget _buildFilters(BuildContext context, HomeController controller) {
    return GestureDetector(
      onTap: () {
        // 🔥 Tampilkan BottomSheet Filter
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Filter Series",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _filterChip(controller, "All", "All", isSeries: true),
                    _filterChip(
                      controller,
                      "One Piece",
                      "onepiece",
                      isSeries: true,
                    ),
                    _filterChip(
                      controller,
                      "Jujutsu Kaisen",
                      "jjk",
                      isSeries: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Urutkan Harga",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    _filterChip(controller, "Default", "none", isSeries: false),
                    _filterChip(controller, "Termurah", "asc", isSeries: false),
                    _filterChip(
                      controller,
                      "Termahal",
                      "desc",
                      isSeries: false,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.filter_list),
            const SizedBox(width: 5),
            Obx(
              () => Text(
                "Filters ${controller.selectedSeries.value != 'All' || controller.sortPrice.value != 'none' ? '• Aktif' : ''}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      controller.selectedSeries.value != 'All' ||
                          controller.sortPrice.value != 'none'
                      ? Colors.pink
                      : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(
    HomeController controller,
    String label,
    String value, {
    required bool isSeries,
  }) {
    return Obx(
      () => ChoiceChip(
        label: Text(label),
        selected: isSeries
            ? controller.selectedSeries.value == value
            : controller.sortPrice.value == value,
        onSelected: (selected) {
          if (selected) {
            if (isSeries)
              controller.selectSeries(value);
            else
              controller.setSortPrice(value);
            Get.back(); // Tutup bottom sheet setelah pilih
          }
        },
        selectedColor: Colors.pinkAccent,
        labelStyle: TextStyle(
          color:
              (isSeries
                  ? controller.selectedSeries.value == value
                  : controller.sortPrice.value == value)
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }

  // ==================== TRENDING (WIDE) ====================
  Widget _buildTrending(Product p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Colors.orange.shade50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.whatshot, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                "Trending Now",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.orange.shade900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Get.to(() => PromoPage()),
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
}
