import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_controller.dart';

class SellerProductService {
  String get baseUrl => AuthController.baseUrl;

  AuthController get _auth => Get.find<AuthController>();

  /// ===========================================================
  /// CREATE PRODUCT (Multipart + Auth)
  /// ===========================================================
  Future<Map<String, dynamic>> createProduct({
    required String name,
    required String category,
    required String description,
    required int price,
    required int stock,
    required int tokoId,
    required String folder,
    required List<XFile> images, // Ubah File jadi XFile
  }) async {
    try {
      if (_auth.token.value.isEmpty) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. User belum login.',
        };
      }

      final uri = Uri.parse('$baseUrl/products');
      final request = http.MultipartRequest('POST', uri);

      // ================= HEADERS =================
      request.headers.addAll(_auth.headers(json: false));

      // ================= FIELDS =================
      request.fields.addAll({
        'name': name,
        'category': category,
        'description': description,
        'price': price.toString(),
        'stock': stock.toString(),
        'toko_id': tokoId.toString(),
        'folder': folder,
      });

      // ================= IMAGES =================
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final filename =
            '${name.replaceAll(' ', '-')}-${(i + 1).toString().padLeft(2, '0')}.jpg';

        print("📤 UPLOAD FILE: ${file.path} as $filename");

        if (kIsWeb) {
          // 🔥 KHUSUS WEB: Kirim Bytes
          final bytes = await file.readAsBytes();
          request.files.add(
            http.MultipartFile.fromBytes('images[]', bytes, filename: filename),
          );
        } else {
          // 📱 MOBILE: Kirim Path
          request.files.add(
            await http.MultipartFile.fromPath(
              'images[]',
              file.path,
              filename: filename,
            ),
          );
        }
      }

      print("📤 TOTAL FILES: ${request.files.length}");

      // ================= SEND =================
      final streamed = await request.send().timeout(
        const Duration(seconds: 25),
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 200 || streamed.statusCode == 201) {
        return {'success': true};
      }

      return {
        'success': false,
        'message': body.isNotEmpty ? body : 'Server error',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// ===========================================================
  /// GET PRODUCTS BY TOKO
  /// ===========================================================
  Future<List<dynamic>> getProductsByToko(int tokoId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/store/$tokoId/products'),
        headers: _auth.headers(json: false),
      );

      print("📦 STATUS = ${response.statusCode}");
      print("📦 BODY = ${response.body}");

      if (response.statusCode != 200) return [];

      final decoded = json.decode(response.body);
      final List<dynamic> products = decoded['products'];

      print("📦 TOTAL PRODUCTS = ${products.length}");

      return products;
    } catch (e) {
      print("❌ ERROR FETCH PRODUCTS: $e");
      return [];
    }
  }

  /// ===========================================================
  /// UPDATE PRODUCT
  /// ===========================================================
  Future<Map<String, dynamic>> getProductForEdit(
    int storeId,
    int productId,
  ) async {
    debugPrint("🌐 [API CALL]");
    debugPrint("➡️ GET /products/$productId");

    debugPrint("🔑 TOKEN = ${_auth.token.value}");

    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId'),
      headers: _auth.headers(json: false),
    );

    debugPrint("🌐 STATUS = ${response.statusCode}");
    debugPrint("🌐 BODY = ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['product'];
    } else {
      throw Exception('Gagal ambil data produk');
    }
  }

  Future<void> updateProduct({
    required int storeId,
    required int productId,
    required AuthController auth,
    required String name,
    required String price,
    required String description,
    required String category,
    required String stock,
  }) async {
    final url = '${AuthController.baseUrl}/store/$storeId/products/$productId';

    debugPrint("🟦 [UPDATE PRODUCT]");
    debugPrint("🌐 PUT $url");

    final response = await http.put(
      Uri.parse(url),
      headers: auth.headers(json: false),
      body: {
        'name': name,
        'price': price,
        'description': description,
        'category': category,
        'stock': stock,
      },
    );

    debugPrint("📡 STATUS = ${response.statusCode}");
    debugPrint("📡 BODY = ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Update produk gagal');
    }
  }

  /// ===========================================================
  /// DELETE PRODUCT
  /// ===========================================================
  Future<bool> deleteProduct(int productId) async {
    debugPrint("🌐 DELETE API CALL");
    debugPrint("🌐 URL = $baseUrl/products/$productId");

    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: _auth.headers(json: false),
    );

    debugPrint("🌐 STATUS = ${response.statusCode}");
    debugPrint("🌐 BODY = ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Delete failed');
    }
  }
}
