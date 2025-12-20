import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'auth_controller.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('${AuthController.baseUrl}/products');
    final auth = Get.find<AuthController>();

    final response = await http.get(url, headers: auth.headers(json: false));

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List list = jsonData['products'] ?? [];
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal ambil data (Status: ${response.statusCode})");
    }
  }
}
