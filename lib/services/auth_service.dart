import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  // ======================
  // REGISTER
  // ======================
  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    return res.statusCode == 200;
  }

  // ======================
  // LOGIN
  // ======================
  static Future<bool> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(res.body);

    if (res.statusCode == 200 && data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return true;
    }

    return false;
  }

  // ======================
  // GET TOKEN
  // ======================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ======================
  // LOGOUT
  // ======================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // cek token
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  // get user
  static Future<Map<String, dynamic>?> getUser() async {
    final token = await getToken();
    if (token == null) return null;

    final res = await http.get(
      Uri.parse("$baseUrl/user"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return null;
  }
}
