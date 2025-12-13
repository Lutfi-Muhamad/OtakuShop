import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth_controller.dart';

class StoreService {
  static const baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  static Future<Map<String, dynamic>> registerStore({
    required String name,
    required String phone,
    required String address,
  }) async {
    final auth = Get.find<AuthController>();
    await auth.loadToken(); // JANGAN ASUMSI

    if (auth.token.value.isEmpty) {
      return {"success": false, "error": "User belum login", "statusCode": 401};
    }

    final url = Uri.parse("$baseUrl/store/register");

    try {
      final response = await http.post(
        url,
        headers: auth.headers(),
        body: jsonEncode({"name": name, "phone": phone, "address": address}),
      );

      print("[STORE REGISTER] status: ${response.statusCode}");
      print("[STORE REGISTER] body: ${response.body}");

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {"success": true, "message": data["message"]};
      }

      return {
        "success": false,
        "error": data["message"] ?? "Terjadi kesalahan",
        "statusCode": response.statusCode,
      };
    } catch (e) {
      return {"success": false, "error": "Request gagal: $e", "statusCode": 0};
    }
  }
}
