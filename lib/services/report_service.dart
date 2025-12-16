import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'package:get/get.dart';

class ReportService {
  static const String baseUrl =
      "https://hubbly-salma-unmaterialistically.ngrok-free.dev/api";

  static Future<List<dynamic>> fetchSales({
    required int storeId,
    String? order, // top | bottom
    String? category, // nendroid | bags | figure
    String? series, // onepiece | jjk
  }) async {
    final auth = Get.find<AuthController>();
    final token = auth.token.value;

    debugPrint("🔐 REPORT TOKEN = '$token'");

    if (token.isEmpty) {
      throw Exception('TOKEN KOSONG. AUTH BELUM SIAP.');
    }

    // build query param
    final params = <String, String>{};

    if (order != null) params['order'] = order;
    if (category != null) params['category'] = category;
    if (series != null) params['series'] = series;

    final uri = Uri.parse(
      "$baseUrl/store/$storeId/reports/sales",
    ).replace(queryParameters: params.isEmpty ? null : params);

    debugPrint("🌐 HIT API: $uri");

    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    debugPrint("📦 STATUS: ${response.statusCode}");
    debugPrint("📦 BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final decoded = json.decode(response.body);
    return decoded['data'];
  }
}
