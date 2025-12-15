import 'package:flutter/material.dart';

import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/common/footer.dart.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/common/product_grid.dart';
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
