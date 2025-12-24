import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  // Getter untuk mengakses nilai boolean dengan mudah
  bool get isDarkMode => _isDarkMode.value;

  // Getter untuk mendapatkan ThemeMode yang sesuai
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  // Memuat preferensi tema dari SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }

  // Mengganti tema dan menyimpan preferensi
  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode.value);
  }
}
