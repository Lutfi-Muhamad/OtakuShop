import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class SellerProductService {
  final String baseUrl =
      "http://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  /// ===========================================================
  /// CREATE / POST PRODUK BARU + MULTIPLE IMAGES
  /// ===========================================================
  Future<bool> createProduct({
    required String name,
    required String description,
    required int price,
    required int stock,
    required String folder, // onepiece / jjk
    required int tokoId,
    required List<File> images,
  }) async {
    final url = Uri.parse("$baseUrl/products");

    var request = http.MultipartRequest("POST", url);

    // === kirim field text ===
    request.fields["name"] = name;
    request.fields["description"] = description;
    request.fields["price"] = price.toString();
    request.fields["stock"] = stock.toString();

    request.fields["image_type"] = "square";
    request.fields["aspect_ratio"] = "1:1";
    request.fields["folder"] = folder;

    request.fields["toko_id"] = tokoId.toString();

    // === rename & upload multiple images ===
    for (int i = 0; i < images.length; i++) {
      String renamed =
          "${name.replaceAll(" ", "-")}-${(i + 1).toString().padLeft(2, '0')}.jpg";

      request.files.add(
        await http.MultipartFile.fromPath(
          "images[]", // laravel must receive as array
          images[i].path,
          filename: renamed,
        ),
      );

      // kirim nama dasar (tanpa -01.jpg)
      if (i == 0) {
        request.fields["image_key"] = name.replaceAll(
          " ",
          "-",
        ); // contoh: Zoro-Nendoroid-limited
      }
    }

    final response = await request.send();

    return response.statusCode == 201;
  }

  /// ===========================================================
  /// GET produk by toko_id
  /// ===========================================================
  Future<List<dynamic>> getProductsByToko(int tokoId) async {
    final response = await http.get(Uri.parse("$baseUrl/products"));

    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      return products.where((p) => p["toko_id"] == tokoId).toList();
    }
    return [];
  }

  // UPDATE PRODUCT
  Future<bool> updateProduct(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/products/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    return response.statusCode == 200;
  }

  // DELETE PRODUCT
  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/products/$id"));

    return response.statusCode == 200;
  }
}
