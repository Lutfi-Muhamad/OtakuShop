import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otakushop/services/auth_controller.dart';

class CartService {
  static const String baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  static Future<bool> addToCart(int productId, {int qty = 1}) async {
    final auth = Get.find<AuthController>();

    if (auth.token.value.isEmpty) {
      return false;
    }

    final res = await http.post(
      Uri.parse("$baseUrl/cart"),
      headers: auth.headers(),
      body: jsonEncode({"product_id": productId, "qty": qty}),
    );

    return res.statusCode == 200 || res.statusCode == 201;
  }
}
