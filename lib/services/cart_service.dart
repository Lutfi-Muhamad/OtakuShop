import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class CartService {
  static const String baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  static Future<bool> addToCart(int productId) async {
    final token = await AuthService.getToken();

    if (token == null) return false;

    final res = await http.post(
      Uri.parse("$baseUrl/cart"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"product_id": productId, "qty": 1}),
    );

    return res.statusCode == 200;
  }
}
