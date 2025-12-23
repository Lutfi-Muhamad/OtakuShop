import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistController extends GetxController {
  var wishlist = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  void loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedString = prefs.getString('wishlist');
    if (storedString != null) {
      final List<dynamic> decoded = jsonDecode(storedString);
      wishlist.value = decoded.map((e) => Product.fromJson(e)).toList();
    }
  }

  void saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(wishlist.map((e) => e.toJson()).toList());
    await prefs.setString('wishlist', encoded);
  }

  void toggleWishlist(Product product) {
    if (isWishlisted(product.id)) {
      wishlist.removeWhere((p) => p.id == product.id);
      Get.snackbar(
        "Wishlist",
        "Dihapus dari wishlist",
        duration: const Duration(seconds: 1),
      );
    } else {
      wishlist.add(product);
      Get.snackbar(
        "Wishlist",
        "Ditambahkan ke wishlist",
        duration: const Duration(seconds: 1),
      );
    }
    saveWishlist();
  }

  bool isWishlisted(int id) {
    return wishlist.any((p) => p.id == id);
  }
}
