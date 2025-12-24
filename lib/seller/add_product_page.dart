import 'dart:io';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otakushop/services/seller_product_service.dart';
import 'package:get/get.dart';
import 'package:otakushop/services/auth_controller.dart';

class AddProductController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  var selectedSeries = RxnString();
  var selectedCategory = RxnString();
  var selectedImages = <XFile>[].obs;
  var isLoading = false.obs;

  final ImagePicker picker = ImagePicker();
  final SellerProductService productService = SellerProductService();
  final AuthController auth = Get.find<AuthController>();

  // ==============================
  // PICK MULTIPLE IMAGES
  // ==============================
  Future<void> pickImages() async {
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isEmpty) return;

    selectedImages.assignAll(files);
  }

  // ==============================
  // SERIES BUTTON
  // ==============================
  Widget choiceSeries(String title, String value) {
    return _choiceBox(
      title: title,
      selected: selectedSeries.value == value,
      onTap: () => selectedSeries.value = value,
    );
  }

  // ==============================
  // CATEGORY BUTTON
  // ==============================
  Widget choiceCategory(String title, String value) {
    return _choiceBox(
      title: title,
      selected: selectedCategory.value == value,
      onTap: () => selectedCategory.value = value,
    );
  }

  Widget _choiceBox({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.pink : Get.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Get.theme.colorScheme.outline),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Get.theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==============================
  // SUBMIT
  // ==============================
  Future<void> submitProduct() async {
    if (isLoading.value) return;

    // if (selectedImages.isEmpty) {
    //   showMsg("Pilih minimal 1 foto");
    //   return;
    // }

    if (selectedSeries.value == null) {
      showMsg("Pilih series produk");
      return;
    }

    if (selectedCategory.value == null) {
      showMsg("Pilih kategori produk");
      return;
    }

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty ||
        descController.text.isEmpty) {
      showMsg("Isi semua form terlebih dahulu");
      return;
    }

    isLoading.value = true;

    try {
      final result = await productService.createProduct(
        name: nameController.text,
        category: selectedCategory.value!,
        description: descController.text,
        price: int.parse(priceController.text),
        stock: int.parse(stockController.text),
        tokoId: auth.user.value?.tokoId ?? 0,
        folder: selectedSeries.value!,
        images: selectedImages,
      );

      if (result["success"] == true) {
        Get.back(result: true);
        showMsg("Produk berhasil ditambahkan");
      } else {
        showMsg(result["message"] ?? "Gagal upload produk");
      }
    } catch (e) {
      showMsg("Koneksi ke server gagal");
    } finally {
      isLoading.value = false;
    }
  }

  void showMsg(String msg) {
    Get.snackbar(
      "Info",
      msg,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }
}

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  // ==============================
  // BUILD UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xffe56484),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color(0xffe56484),
        elevation: 0,
        title: const Text(
          "Add Product",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Foto Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: controller.pickImages,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Obx(
                      () => controller.selectedImages.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 60,
                                color: Colors.grey,
                              ),
                            )
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: controller.selectedImages.map((img) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: kIsWeb
                                      ? Image.network(img.path, height: 150)
                                      : Image.file(File(img.path), height: 150),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Series",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      controller.choiceSeries("One Piece", "onepiece"),
                      controller.choiceSeries("JJK", "jjk"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Kategori",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      controller.choiceCategory("Nendoroid", "nendoroid"),
                      controller.choiceCategory("Bags", "bags"),
                      controller.choiceCategory("Figure", "figure"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                makeField(context, "Nama Produk", controller.nameController),
                const SizedBox(height: 16),
                makeField(
                  context,
                  "Harga",
                  controller.priceController,
                  type: TextInputType.number,
                ),
                const SizedBox(height: 16),
                makeField(
                  context,
                  "Stok",
                  controller.stockController,
                  type: TextInputType.number,
                ),
                const SizedBox(height: 16),
                makeField(
                  context,
                  "Deskripsi",
                  controller.descController,
                  lines: 4,
                ),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "Confirm",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeField(
    BuildContext context,
    String title,
    TextEditingController c, {
    int lines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          keyboardType: type,
          maxLines: lines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
