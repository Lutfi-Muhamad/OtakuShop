import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse(
      'https://hubbly-salma-unmaterialistically.ngrok-free.dev/api/products',
    );

    final response = await http.get(
      url,
      headers: {
        "ngrok-skip-browser-warning": "true",
        "Accept": "application/json",
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List list = jsonData['products'];
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }
}
