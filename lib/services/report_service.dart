import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otakushop/services/auth_controller.dart';

class ReportService {
  static String get baseUrl => AuthController.baseUrl;

  // ===================================================
  // CHART SALES (AGREGASI PER HARI / RANGE WAKTU)
  // Endpoint:
  // GET /store/{id}/reports/sales?start_date=&end_date=
  // Return:
  // date, total_sold, total_revenue
  // ===================================================
  static Future<List<dynamic>> fetchChartSales({
    required int storeId,
    String? startDate, // yyyy-MM-dd
    String? endDate,
  }) async {
    final auth = Get.find<AuthController>();

    final params = <String, String>{};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;

    final uri = Uri.parse(
      "$baseUrl/store/$storeId/reports/sales",
    ).replace(queryParameters: params.isEmpty ? null : params);

    debugPrint("📈 HIT CHART API: $uri");

    final response = await http.get(uri, headers: auth.headers(json: false));

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return json.decode(response.body)['data'];
  }

  // ===================================================
  // PRODUCT SALES (TOTAL / BEST / LIST PER PRODUK)
  // Endpoint:
  // GET /store/{id}/reports/product-sales
  // Return:
  // product_name, category, series, total_sold, total_revenue
  // ===================================================
  static Future<List<dynamic>> fetchProductSales({
    required int storeId,
    String? order, // top | bottom
    String? category, // nendroid | bags | figure
    String? series, // onepiece | jjk
  }) async {
    final auth = Get.find<AuthController>();

    final params = <String, String>{};
    if (order != null) params['order'] = order;
    if (category != null) params['category'] = category;
    if (series != null) params['series'] = series;

    final uri = Uri.parse(
      "$baseUrl/store/$storeId/reports/product-sales",
    ).replace(queryParameters: params.isEmpty ? null : params);

    debugPrint("📦 HIT PRODUCT SALES API: $uri");

    final response = await http.get(uri, headers: auth.headers(json: false));

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return json.decode(response.body)['data'];
  }
}
