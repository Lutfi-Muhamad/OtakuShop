import 'package:otakushop/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StoreService {
  static const baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev";

  static Future<Map<String, dynamic>> registerStore({
    required String name,
    required String phone,
    required String address,
  }) async {
    final token = await AuthService.getToken(); // ← WAJIB

    if (token == null) {
      return {
        "success": false,
        "error": "Token not found. User might not be logged in.",
      };
    }

    final url = Uri.parse("$baseUrl/api/store/register");

    try {
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token", // ← INI YANG KAMU KURANGI
              "Accept": "application/json",
            },
            body: jsonEncode({
              "name": name,
              "phone": phone,
              "address": address,
            }),
          )
          .timeout(const Duration(seconds: 30));

      return {
        "success": response.statusCode == 200 || response.statusCode == 201,
        "statusCode": response.statusCode,
        "body": response.body,
      };
    } catch (e) {
      return {"success": false, "error": e.toString()};
    }
  }
}
