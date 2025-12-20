import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otakushop/common/navbar.dart';
import 'package:otakushop/common/drawer_widget.dart';
import 'package:otakushop/services/seller_product_service.dart';
import 'package:otakushop/services/auth_controller.dart';

class EditSellerPage extends StatefulWidget {
  final int productId;
  final int storeId;

  const EditSellerPage({
    super.key,
    required this.productId,
    required this.storeId,
  });

  @override
  State<EditSellerPage> createState() => _EditSellerPageState();
}

class _EditSellerPageState extends State<EditSellerPage> {
  // ✅ CONTROLLERS (INI YANG TADI KURANG)
  final TextEditingController nameC = TextEditingController();
  final TextEditingController priceC = TextEditingController();
  final TextEditingController descC = TextEditingController();
  final TextEditingController stockC = TextEditingController();
  final TextEditingController categoryC = TextEditingController();
  bool isLoading = true;

  final AuthController auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();

    debugPrint("🟨 [EDIT SELLER PAGE]");
    debugPrint("🚪 PAGE OPENED");
    debugPrint("📦 productId = ${widget.productId}");
    debugPrint("🏪 storeId = ${widget.storeId}");
    debugPrint("✅ LOGIC PAGE SUDAH MASUK");
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    try {
      final data = await SellerProductService().getProductForEdit(
        widget.storeId,
        widget.productId,
      );

      setState(() {
        nameC.text = data['name'] ?? '';
        priceC.text = data['price'].toString();
        descC.text = data['description'] ?? '';
        stockC.text = data['stock'].toString();
        categoryC.text = data['category'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Gagal load data: $e");
      Get.snackbar("Error", "Gagal memuat data produk");
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    priceC.dispose();
    descC.dispose();
    stockC.dispose();
    categoryC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFFF88B7),
      body: SafeArea(
        child: Column(
          children: [
            const PinkNavbar(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Edit Produk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label("Nama"),
                            _input(controller: nameC),

                            const SizedBox(height: 12),

                            _label("Harga"),
                            _input(
                              controller: priceC,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 12),

                            _label("Stok"),
                            _input(
                              controller: stockC,
                              keyboardType: TextInputType.number,
                            ),

                            const SizedBox(height: 12),

                            _label("Kategori"),
                            _input(controller: categoryC),

                            const SizedBox(height: 12),

                            _label("Deskripsi"),
                            TextField(
                              controller: descC,
                              maxLines: 4,
                              decoration: _decoration(),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _saveProduct,
                                child: const Text("Simpan"),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SAVE LOGIC (PUT API)
  // =========================
  Future<void> _saveProduct() async {
    debugPrint("💾 SAVE CLICKED");
    debugPrint("📦 productId = ${widget.productId}");
    debugPrint("🏪 storeId = ${widget.storeId}");
    debugPrint("✏️ name = ${nameC.text}");
    debugPrint("💰 price = ${priceC.text}");
    debugPrint("📝 desc = ${descC.text}");

    try {
      await SellerProductService().updateProduct(
        storeId: widget.storeId,
        productId: widget.productId,
        auth: auth, // ⬅️ pakai AuthController kamu
        name: nameC.text,
        price: priceC.text,
        description: descC.text,
        category: categoryC.text,
        stock: stockC.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Produk berhasil diupdate")));

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("❌ UPDATE ERROR = $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // =========================
  // HELPER
  // =========================
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _input({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _decoration(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
