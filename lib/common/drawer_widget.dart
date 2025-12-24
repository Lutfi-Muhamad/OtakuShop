import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/wishlist_page.dart';
import '../services/auth_controller.dart';
import '../services/theme_controller.dart';
import '../seller/seller_page.dart';
import '../analytics/best_sales_page.dart';
import '../analytics/chart_page.dart';
import '../analytics/total_sales_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(
            () => UserAccountsDrawerHeader(
              accountName: Text(auth.user.value?.name ?? 'Guest'),
              accountEmail: auth.user.value == null
                  ? const Text('Silakan login')
                  : null, // Email disembunyikan karena belum ada di Model User
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    auth.user.value?.photo != null &&
                        auth.user.value!.photo!.isNotEmpty
                    ? NetworkImage(
                        AuthController.getImageUrl(auth.user.value!.photo!),
                      )
                    : null,
                child:
                    auth.user.value?.photo == null ||
                        auth.user.value!.photo!.isEmpty
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              decoration: const BoxDecoration(color: Colors.pink),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Get.back(); // Close drawer
              if (Get.currentRoute != '/') {
                Get.offAllNamed('/');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Wishlist'),
            onTap: () {
              Get.back();
              Get.to(() => const WishlistPage());
            },
          ),
          Obx(() {
            final user = auth.user.value;
            if (user != null && user.tokoId != null) {
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.store_outlined),
                    title: const Text('Toko Saya'),
                    onTap: () {
                      Get.back();
                      Get.to(() => const SellerPage());
                    },
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.analytics_outlined),
                    title: const Text('Analytics'),
                    children: [
                      ListTile(
                        title: const Text('Total Penjualan'),
                        onTap: () {
                          Get.back();
                          Get.to(() => const TotalSalesPage());
                        },
                      ),
                      ListTile(
                        title: const Text('Paling laku'),
                        onTap: () {
                          Get.back();
                          Get.to(() => const BestSalesPage());
                        },
                      ),
                      ListTile(
                        title: const Text('Grafik Penjualan'),
                        onTap: () {
                          Get.back();
                          Get.to(() => const ChartPage());
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          const Divider(),
          Obx(
            () => SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme();
              },
              secondary: Icon(
                themeController.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
          ),
          const Divider(),
          Obx(
            () => auth.token.value.isEmpty
                ? ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Get.back();
                      Get.toNamed('/login');
                    },
                  )
                : ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () =>
                        auth.logout().then((_) => Get.offAllNamed('/')),
                  ),
          ),
        ],
      ),
    );
  }
}
