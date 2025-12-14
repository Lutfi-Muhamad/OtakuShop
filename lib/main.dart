import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otakushop/pages/home_page.dart';
import 'package:otakushop/pages/login_page.dart';
import 'package:otakushop/seller/user_profile_page.dart';
import 'package:otakushop/services/auth_controller.dart';

void main() {
  // inject controller SEKALI sebelum app jalan
  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF87DAF)),
        useMaterial3: true,
      ),

      // entry point aplikasi
      initialRoute: '/',

      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/profile', page: () => UserPage()),
      ],
    );
  }
}
