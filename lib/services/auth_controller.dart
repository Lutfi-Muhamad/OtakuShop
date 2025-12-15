import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otakushop/models/user.dart';
import 'dart:io';

class AuthController extends GetxController {
  // ================= STATE =================
  final token = ''.obs;
  final user = Rxn<User>();

  static const String baseUrl =
      'https://hubbly-salma-unmaterialistically.ngrok-free.dev/api';

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
  }

  // ================= HELPER =================
  String api(String path) => '$baseUrl$path';

  Map<String, String> headers({bool json = true}) {
    final h = <String, String>{
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
    };

    if (json) {
      h['Content-Type'] = 'application/json; charset=UTF-8';
    }

    if (token.value.isNotEmpty) {
      h['Authorization'] = 'Bearer ${token.value}';
    }

    return h;
  }

  // ================= TOKEN =================
  Future<void> saveToken(String t) async {
    token.value = t;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', t);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('auth_token') ?? '';
  }

  // ================= FETCH USER =================
  Future<void> refreshUser() async {
    print('========== REFRESH USER START ==========');

    if (token.value.isEmpty) {
      print('[DEBUG] token kosong → user = null');
      user.value = null;
      return;
    }

    final uri = Uri.parse(api('/user'));
    final res = await http.get(uri, headers: headers(json: false));

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      user.value = User.fromJson(decoded['user']);

      print('[DEBUG] tokoId = ${user.value?.tokoId}');
    } else {
      user.value = null;
    }

    print('========== REFRESH USER END ==========');
  }

  // ================= REGISTER =================
  Future<bool> register(String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse(api('/register')),
        headers: headers(),
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );

      if (res.statusCode != 200) return false;

      final data = jsonDecode(res.body);
      final tokenFromBackend = data['token'];
      if (tokenFromBackend == null) return false;

      await saveToken(tokenFromBackend);
      await refreshUser();
      return true;
    } catch (e) {
      print('[REGISTER] error: $e');
      return false;
    }
  }

  // ================= LOGIN =================
  Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse(api('/login')),
        headers: headers(),
        body: jsonEncode({"email": email, "password": password}),
      );

      print('[LOGIN] status: ${res.statusCode}');
      print('[LOGIN] body: ${res.body}');

      if (res.statusCode != 200) return false;

      final data = jsonDecode(res.body);
      final tokenFromBackend = data['token'];
      if (tokenFromBackend == null) return false;

      await saveToken(tokenFromBackend);
      await refreshUser();
      return true;
    } catch (e) {
      print('[LOGIN] error: $e');
      return false;
    }
  }

  /// ================= UPDATE PROFILE DENGAN FOTO =================
  Future<bool> updateProfile({
    required String name,
    required String bio,
    required String address,
    File? photoFile,
  }) async {
    try {
      await loadToken();
      if (token.value.isEmpty) return false;

      final uri = Uri.parse(api('/user/update')); // pastikan endpoint
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer ${token.value}',
        'Accept': 'application/json',
      });

      // Fields
      request.fields['name'] = name;
      request.fields['bio'] = bio;
      request.fields['address'] = address;

      // File
      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photoFile.path),
        );
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user.value = User.fromJson(data['user']); // update local user
        return true;
      }

      print('[UPDATE PROFILE] ERROR: ${response.body}');
      return false;
    } catch (e) {
      print('[UPDATE PROFILE] EXCEPTION: $e');
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<bool> logout() async {
    try {
      final res = await http.post(
        Uri.parse(api('/logout')),
        headers: headers(json: false),
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        token.value = '';
        user.value = null;
        return true;
      }
      return false;
    } catch (e) {
      print('[LOGOUT] error: $e');
      return false;
    }
  }
}
