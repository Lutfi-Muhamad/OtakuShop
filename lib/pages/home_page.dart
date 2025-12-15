import 'package:flutter/material.dart';
import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/common/footer.dart.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/pages/product_detail_page.dart';
import 'package:otakushop/pages/promo_page.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // ← WAJIB di Scaffold utama
      body: FutureBuilder<List<Product>>(
        future: ProductService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada"));
          }

          final products = snapshot.data!;
          final squares = products
              .where((p) => p.imageType == "square")
              .toList();
          final wides = products.where((p) => p.imageType == "wide").toList();

          return CustomScrollView(
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
                    const SearchBarWidget(),

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
                    _buildCategories(),
                    const SizedBox(height: 10),
                    _buildFilters(),
                    const SizedBox(height: 20),

                    // GRID PRODUK (SQUARE)
                    _buildProductGrid(context, squares),

                    const SizedBox(height: 30),

                    // TRENDING (WIDE)
                    if (wides.isNotEmpty) _buildTrending(wides.first),

                    const SizedBox(height: 20),

                    // LIST BAWAH
                    _buildAnotherProductList(context, squares),

                    const SizedBox(height: 50),
                    _buildSeriesButton(),
                    const SizedBox(height: 50),
                    const FooterWidget(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
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
  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _categoryItem(Icons.toys, "Nendoroid"),
        _categoryItem(Icons.backpack, "Backpack"),
        _categoryItem(Icons.star, "Figure"),
      ],
    );
  }

  Widget _categoryItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(radius: 28, child: Icon(icon, size: 30)),
        SizedBox(height: 6),
        Text(label),
      ],
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

  // ==================== GRID PRODUK ====================
  Widget _buildProductGrid(BuildContext context, List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, i) {
        return _productCard(context, products[i]);
      },
    );
  }

  Widget _productCard(BuildContext context, Product p) {
    final hasImage = p.images.isNotEmpty;
    final imageUrl = hasImage ? p.images.first : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ GAMBAR AMAN
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: hasImage
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: hasImage ? null : Colors.grey.shade200,
              ),
              child: !hasImage
                  ? const Center(child: Icon(Icons.image_not_supported))
                  : null,
            ),

            const SizedBox(height: 8),

            // Badge
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                "Limited",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                p.price != null ? "IDR ${p.price}" : "—",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
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
                image: DecorationImage(
                  image: NetworkImage(
                    p.images.isNotEmpty
                        ? p.images.first
                        : 'https://via.placeholder.com/150',
                  ),

                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== LIST BAWAH ====================
  Widget _buildAnotherProductList(
    BuildContext context,
    List<Product> products,
  ) {
    return Column(
      children: products
          .take(2)
          .map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _productCard(context, p),
            ),
          )
          .toList(),
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
