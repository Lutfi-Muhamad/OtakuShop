import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthController extends GetxController {
  final token = ''.obs;
  final userName = ''.obs;

  static const String baseUrl =
      'https://hubbly-salma-unmaterialistically.ngrok-free.dev/api';

  String api(String path) => '$baseUrl$path';

  Map<String, String> headers({bool json = true}) {
    final h = <String, String>{'Accept': 'application/json'};

    if (json) {
      h['Content-Type'] = 'application/json; charset=UTF-8';
    }

    if (token.value.isNotEmpty) {
      h['Authorization'] = 'Bearer ${token.value}';
    }

    // ngrok noise suppressor
    h['ngrok-skip-browser-warning'] = 'true';

    return h;
  }

  Future<void> saveToken(String t) async {
    token.value = t;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', t);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final stored =
        prefs.getString('auth_token') ?? prefs.getString('token') ?? '';
    if (stored.isNotEmpty) token.value = stored;
  }

  Future<bool> logout() async {
    try {
      await loadToken(); // JANGAN ASUMSI TOKEN SUDAH ADA

      final uri = Uri.parse(api('/logout')); // FIX DI SINI
      final response = await http.post(uri, headers: headers(json: false));

      if (response.statusCode == 200 || response.statusCode == 204) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        token.value = '';
        userName.value = '';
        return true;
      }

      print(
        '[AuthController] logout failed '
        '${response.statusCode}: ${response.body}',
      );
      return false;
    } catch (e, stack) {
      print('[AuthController] logout exception: $e');
      print(stack);
      return false;
    }
  }
}
