import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../seller/user_profile_page.dart';
import '../services/auth_controller.dart';
import '../services/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _requestPermissions();

  Get.put(AuthController(), permanent: true);
  Get.put(ThemeController(), permanent: true);
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await [Permission.photos, Permission.storage].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FAW',
        // Tema untuk Mode Terang
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF87DAF)),
          useMaterial3: true,
        ),
        // Tema untuk Mode Gelap
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF87DAF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        // Mengatur mode tema dari controller
        themeMode: themeController.themeMode,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => const HomePage()),
          GetPage(name: '/login', page: () => const LoginPage()),
          GetPage(name: '/profile', page: () => UserPage()),
        ],
      ),
    );
  }
}
