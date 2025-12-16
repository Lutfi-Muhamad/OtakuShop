import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'auth_controller.dart';

class SellerProductService {
  final String baseUrl =
      'https://hubbly-salma-unmaterialistically.ngrok-free.dev/api';

  AuthController get _auth => Get.find<AuthController>();

  /// ===========================================================
  /// CREATE PRODUCT (Multipart + Auth)
  /// ===========================================================
  Future<Map<String, dynamic>> createProduct({
    required String name,
    required String description,
    required int price,
    required int stock,
    required String folder,
    required int tokoId,
    required List<File> images,
  }) async {
    try {
      // pastikan token sudah dimuat
      await _auth.loadToken();

      if (_auth.token.value.isEmpty) {
        return {
          'success': false,
          'message': 'Token tidak ditemukan. User belum login.',
        };
      }

      final uri = Uri.parse('$baseUrl/products');
      final request = http.MultipartRequest('POST', uri);

      // ================= HEADERS =================
      request.headers.addAll({
        'Authorization': 'Bearer ${_auth.token.value}',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      });

      // ================= FIELDS =================
      request.fields.addAll({
        'name': name,
        'description': description,
        'price': price.toString(),
        'stock': stock.toString(),
        'folder': folder,
        'toko_id': tokoId.toString(),
        'image_type': 'square',
        'aspect_ratio': '1:1',
        'image_key': name.replaceAll(' ', '-'),
      });

      // ================= IMAGES =================
      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final filename =
            '${name.replaceAll(' ', '-')}-${(i + 1).toString().padLeft(2, '0')}.jpg';

        print("📤 UPLOAD FILE: ${file.path} as $filename");

        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // <- PENTING
            file.path,
            filename: filename,
          ),
        );
      }

      print("📤 TOTAL FILES: ${request.files.length}");

      // ================= SEND =================
      final streamed = await request.send().timeout(
        const Duration(seconds: 25),
      );

      final body = await streamed.stream.bytesToString();

      if (streamed.statusCode == 201) {
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
      await _auth.loadToken();

      final response = await http.get(
        Uri.parse('$baseUrl/store/$tokoId/products'),
        headers: {
          'Authorization': 'Bearer ${_auth.token.value}',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
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
    debugPrint("➡️ GET /store/$storeId/products/$productId");

    await _auth.loadToken();

    debugPrint("🔑 TOKEN = ${_auth.token.value}");

    final response = await http.get(
      Uri.parse('$baseUrl/store/$storeId/products/$productId'),
      headers: {
        'Authorization': 'Bearer ${_auth.token.value}',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    );

    debugPrint("🌐 STATUS = ${response.statusCode}");
    debugPrint("🌐 BODY = ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['product'];
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
  }) async {
    await auth.loadToken();

    final url = '${AuthController.baseUrl}/store/$storeId/products/$productId';

    debugPrint("🟦 [UPDATE PRODUCT]");
    debugPrint("🌐 PUT $url");

    final response = await http.put(
      Uri.parse(url),
      headers: auth.headers(json: false), // 🔥 PAKAI AUTH CONTROLLER
      body: {'name': name, 'price': price, 'description': description},
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
  Future<bool> deleteProduct(int productId, String token) async {
    debugPrint("🌐 DELETE API CALL");
    debugPrint("🌐 URL = $baseUrl/products/$productId");
    debugPrint("🌐 TOKEN = $token");

    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'ngrok-skip-browser-warning': 'true',
      },
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
