import 'package:flutter/material.dart';
import 'package:otakushop/common/footer.dart.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/searchbar.dart';
import 'package:otakushop/pages/product_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Color(0xFFF87DAF),
            expandedHeight: 60,
            flexibleSpace: const FlexibleSpaceBar(background: PinkNavbar()),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 20),
                const SearchBarWidget(),

                SizedBox(height: 20),
                _buildBannerPromo(),
                SizedBox(height: 20),
                _buildCategories(),
                SizedBox(height: 10),
                _buildFilters(),
                SizedBox(height: 20),
                _buildProductGrid(context),
                SizedBox(height: 30),
                _buildTrending(),
                SizedBox(height: 20),
                _buildAnotherProductList(context),
                SizedBox(height: 50),
                _buildSeriesButton(),
                SizedBox(height: 50),
                const FooterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildProductGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.65,
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        _productCard(context, "Gojo Satoru - Nendoroid", "IDR 350,000"),
        _productCard(context, "Nami - Nendoroid", "IDR 350,000"),
      ],
    );
  }

  // FIX: tambahkan BuildContext di parameter
  Widget _productCard(BuildContext context, String title, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(title: title, price: price),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
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
            // Gambar
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey.shade300,
              ),
            ),

            const SizedBox(height: 8),

            // Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Limited",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                price,
                style: TextStyle(color: Colors.red),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTrending() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Text(
            "Trending",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          height: 160,
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  // FIX: tambah parameter context
  Widget _buildAnotherProductList(BuildContext context) {
    return Column(
      children: [
        _productCard(context, "Gojo Satoru - Nendoroid", "IDR 500,000"),
        SizedBox(height: 20),
        _productCard(context, "Gojo Satoru - Nendoroid", "IDR 500,000"),
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
