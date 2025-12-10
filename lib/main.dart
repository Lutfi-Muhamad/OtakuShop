import 'package:flutter/material.dart';
import 'package:otakushop/pages/home_page.dart';
import 'package:otakushop/pages/login_page.dart';
import 'package:otakushop/pages/user_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF87DAF)),
        useMaterial3: true,
      ),

      // entry point aplikasi
      initialRoute: '/',

      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/profile': (context) => const UserPage(),
      },
    );
  }
}
