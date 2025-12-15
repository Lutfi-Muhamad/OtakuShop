import 'package:flutter/material.dart';
import 'package:otakushop/analytics/best_sales_page.dart';
import 'package:otakushop/analytics/chart_page.dart';
import 'package:otakushop/analytics/total_sales.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BACK / CLOSE
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 20),

              _drawerButton(
                context,
                title: "Total Sales",
                page: const TotalSalesPage(),
              ),

              _drawerButton(
                context,
                title: "Best Seller Item",
                page: const BestSellerPage(),
              ),

              _drawerButton(
                context,
                title: "Cart Sales",
                page: const ChartPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerButton(
    BuildContext context, {
    required String title,
    required Widget page,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          Navigator.pop(context); // tutup drawer dulu
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE6EE),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
