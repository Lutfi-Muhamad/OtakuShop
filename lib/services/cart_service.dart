import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otakushop/services/auth_controller.dart';

class CartController extends GetxController {
  var totalItems = 0.obs;
  final auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // Update cart saat user login/logout atau aplikasi mulai
    ever(auth.user, (_) => fetchCartCount());
    fetchCartCount();
  }

  Future<void> fetchCartCount() async {
    if (auth.token.value.isEmpty) {
      totalItems.value = 0;
      return;
    }

    try {
      final res = await http.get(
        Uri.parse("${AuthController.baseUrl}/cart"),
        headers: auth.headers(json: false),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List carts = data['carts'] ?? [];
        totalItems.value = carts.length; // Hitung jumlah item unik
      }
    } catch (e) {
      print("Error fetching cart count: $e");
    }
  }
}

class CartService {
  static String get baseUrl => AuthController.baseUrl;

  static Future<bool> addToCart(
    int productId,
    int storeId, {
    int qty = 1,
  }) async {
    final auth = Get.find<AuthController>();

    print('🛒 ADD TO CART');
    print('🧾 token = "${auth.token.value}"');
    print('🧾 instanceId = ${auth.instanceId}');
    print('📦 productId = $productId');
    print('🏪 storeId = $storeId');
    print('📦 qty = $qty');

    if (auth.token.value.isEmpty) {
      print('❌ TOKEN KOSONG → redirect login');
      return false;
    }

    final res = await http.post(
      Uri.parse("$baseUrl/cart"),
      headers: auth.headers(),
      body: jsonEncode({
        "product_id": productId,
        "store_id": storeId,
        "qty": qty,
      }),
    );

    print('📡 status = ${res.statusCode}');
    print('📡 body = ${res.body}');

    final success = res.statusCode == 200 || res.statusCode == 201;

    if (success && Get.isRegistered<CartController>()) {
      Get.find<CartController>().fetchCartCount();
    }

    return success;
  }

  // =========================
  // FETCH ORDER HISTORY
  // =========================
  static Future<List<dynamic>> fetchOrders() async {
    final auth = Get.find<AuthController>();
    if (auth.token.value.isEmpty) return [];

    try {
      final res = await http.get(
        Uri.parse("$baseUrl/orders"),
        headers: auth.headers(json: false),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['orders'] ?? [];
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
    return [];
  }
}
