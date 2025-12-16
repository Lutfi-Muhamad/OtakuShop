import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:get/get.dart';

class ReportService {
  static const String baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  static Future<List<dynamic>> fetchTotalSales({required int storeId}) async {
    final auth = Get.find<AuthController>();

    final token = auth.token.value;

    debugPrint("🔐 REPORT TOKEN = '$token'");

    if (token.isEmpty) {
      throw Exception('TOKEN KOSONG. AUTH BELUM SIAP.');
    }

    final url = Uri.parse("$baseUrl/store/$storeId/reports/total-sales");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    debugPrint("📦 STATUS: ${response.statusCode}");
    debugPrint("📦 BODY: ${response.body}");

    final decoded = json.decode(response.body);
    return decoded['data'];
  }

// Best
  static Future<List<dynamic>> fetchBestSales({
    required int storeId,
    String? category,
  }) async {
    final auth = Get.find<AuthController>();

    final token = auth.token.value;
    if (token.isEmpty) {
      throw Exception('TOKEN KOSONG');
    }

    final query = category != null ? '?category=$category' : '';
    final url = Uri.parse("$baseUrl/store/$storeId/reports/best-sales$query");

    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }

    final decoded = jsonDecode(res.body);
    return decoded['data'];
  }
}
