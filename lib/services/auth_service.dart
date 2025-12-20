import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


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

    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body);

    if (data['token'] != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return true;
    }

    return false;
  }

  // ======================
  // TOKEN
  // ======================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final token = await getToken();

    if (token != null) {
      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // ======================
  // FETCH USER (INI KUNCI)
  // ======================
  static Future<Map<String, dynamic>> fetchUser() async {
    final token = await getToken();

    if (token == null) {
      throw Exception('No token');
    }

    final res = await http.get(
      Uri.parse("$baseUrl/user"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception('Unauthenticated');
  }

  // ======================
  // UPDATE USER
  // ======================
  static Future<bool> updateProfile({
    required String name,
    required String? bio,
    required String? address,
    File? photoFile,
  }) async {
    final token = await getToken();
    final uri = Uri.parse("$baseUrl/user/update");

    var request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = "Bearer $token";
    request.fields['name'] = name;
    request.fields['bio'] = bio ?? "";
    request.fields['address'] = address ?? "";

    if (photoFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('photo', photoFile.path),
      );
    }

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    final json = jsonDecode(responseData);

    return json["status"] == true;
  }
}
