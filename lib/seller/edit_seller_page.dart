import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../common/navbar.dart';
import '../common/drawer_widget.dart';
import '../services/seller_product_service.dart';
import '../services/auth_controller.dart';

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
  late EditSellerController controller;

  @override
  void initState() {
    super.initState();
    // 🔥 Inisialisasi Controller dengan Tag unik (agar tidak bentrok jika buka banyak edit page)
    controller = Get.put(
      EditSellerController(
        productId: widget.productId,
        storeId: widget.storeId,
      ),
      tag: 'edit_${widget.productId}',
    );
  }

  @override
  void dispose() {
    // Hapus controller dari memori saat halaman ditutup
    Get.delete<EditSellerController>(tag: 'edit_${widget.productId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFFF88B7),
      body: SafeArea(
        child: Column(
          children: [
            const PinkNavbar(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Edit Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ================= FOTO PRODUK =================
                        _label(context, "Foto Produk"),
                        const SizedBox(height: 8),
                        _buildImageSection(context),
                        const SizedBox(height: 20),

                        // ================= FORM =================
                        _label(context, "Nama"),
                        _input(context, controller: controller.nameC),

                        const SizedBox(height: 12),

                        _label(context, "Harga"),
                        _input(
                          context,
                          controller: controller.priceC,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 12),

                        _label(context, "Stok"),
                        _input(
                          context,
                          controller: controller.stockC,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 12),

                        _label(context, "Kategori"),
                        _input(context, controller: controller.categoryC),

                        const SizedBox(height: 12),

                        _label(context, "Deskripsi"),
                        TextField(
                          controller: controller.descC,
                          maxLines: 4,
                          decoration: _decoration(context),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => controller.saveProduct(context),
                            child: const Text("Simpan Perubahan"),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // IMAGE SECTION UI
  // =========================
  Widget _buildImageSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // TOMBOL TAMBAH FOTO
          GestureDetector(
            onTap: controller.pickImages,
            child: Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Icon(Icons.add_a_photo, color: Colors.grey),
            ),
          ),

          // LIST FOTO LAMA (NETWORK)
          ...controller.existingImages.map((url) {
            return Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(AuthController.getImageUrl(url)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => controller.removeExistingImage(url),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),

          // LIST FOTO BARU (FILE)
          ...controller.newImages.map((file) {
            return Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(File(file.path)),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => controller.removeNewImage(file),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // =========================
  // HELPER
  // =========================
  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _input(
    BuildContext context, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _decoration(context),
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}

// =========================================================
// 🔥 CONTROLLER (LOGIC GETX)
// =========================================================
class EditSellerController extends GetxController {
  final int productId;
  final int storeId;

  EditSellerController({required this.productId, required this.storeId});

  final nameC = TextEditingController();
  final priceC = TextEditingController();
  final descC = TextEditingController();
  final stockC = TextEditingController();
  final categoryC = TextEditingController();

  var isLoading = true.obs;
  var existingImages = <String>[].obs; // URL gambar lama
  var newImages = <XFile>[].obs; // File gambar baru
  var imagesToDelete = <String>[].obs; // URL yang akan dihapus

  final AuthController auth = Get.find<AuthController>();
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadProductData();
  }

  // 1. LOAD DATA
  Future<void> loadProductData() async {
    try {
      final data = await SellerProductService().getProductForEdit(
        storeId,
        productId,
      );

      nameC.text = data['name'] ?? '';
      priceC.text = data['price'].toString();
      descC.text = data['description'] ?? '';
      stockC.text = data['stock'].toString();
      categoryC.text = data['category'] ?? '';

      // Load gambar lama
      if (data['images'] != null) {
        existingImages.assignAll(List<String>.from(data['images']));
      }

      isLoading.value = false;
    } catch (e) {
      debugPrint("❌ Gagal load data: $e");
      Get.snackbar("Error", "Gagal memuat data produk");
    }
  }

  // 2. PICK IMAGES
  Future<void> pickImages() async {
    final List<XFile> files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      newImages.addAll(files);
    }
  }

  // 3. REMOVE IMAGE
  void removeExistingImage(String url) {
    existingImages.remove(url);
    imagesToDelete.add(url); // Tandai untuk dihapus di backend
  }

  void removeNewImage(XFile file) {
    newImages.remove(file);
  }

  // 4. SAVE PRODUCT
  Future<void> saveProduct(BuildContext context) async {
    try {
      // NOTE: Pastikan SellerProductService.updateProduct sudah mendukung parameter images
      // Jika belum, kamu perlu mengupdate service tersebut.
      await SellerProductService().updateProduct(
        storeId: storeId,
        productId: productId,
        auth: auth,
        name: nameC.text,
        price: priceC.text,
        description: descC.text,
        category: categoryC.text,
        stock: stockC.text,
        newImages: newImages,
        imagesToDelete: imagesToDelete,
      );

      Get.snackbar(
        "Sukses",
        "Produk berhasil diupdate",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("❌ UPDATE ERROR = $e");
      Get.snackbar(
        "Gagal",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameC.dispose();
    priceC.dispose();
    descC.dispose();
    stockC.dispose();
    categoryC.dispose();
    super.onClose();
  }
}
