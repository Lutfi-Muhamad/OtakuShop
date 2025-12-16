import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otakushop/services/seller_product_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  String? selectedSeries;
  String? selectedCategory;
  List<File> selectedImages = [];

  final ImagePicker picker = ImagePicker();
  final SellerProductService productService = SellerProductService();

  int tokoId = 2;

  // ==============================
  // PICK MULTIPLE IMAGES
  // ==============================
  Future<void> pickImages() async {
    final List<XFile>? files = await picker.pickMultiImage();
    if (files != null) {
      setState(() {
        selectedImages = files.map((e) => File(e.path)).toList();
      });
    }
  }

  // ==============================
  // SERIES BUTTON
  // ==============================
  Widget choiceSeries(String title, String value) {
    return _choiceBox(
      title: title,
      selected: selectedSeries == value,
      onTap: () => setState(() => selectedSeries = value),
    );
  }

  // ==============================
  // CATEGORY BUTTON
  // ==============================
  Widget choiceCategory(String title, String value) {
    return _choiceBox(
      title: title,
      selected: selectedCategory == value,
      onTap: () => setState(() => selectedCategory = value),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.pink : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
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
    if (selectedImages.isEmpty) {
      showMsg("Pilih minimal 1 foto");
      return;
    }

    if (selectedSeries == null) {
      showMsg("Pilih series produk");
      return;
    }

    if (selectedCategory == null) {
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

    try {
      final result = await productService.createProduct(
        name: nameController.text,
        category: selectedCategory!, // ← TERKIRIM
        description: descController.text,
        price: int.parse(priceController.text),
        stock: int.parse(stockController.text),
        folder: selectedSeries!,
        tokoId: tokoId,
        images: selectedImages,
      );

      if (!mounted) return;

      if (result["success"] == true) {
        Navigator.pop(context);
        showMsg("Produk berhasil ditambahkan");
      } else {
        showMsg(result["message"] ?? "Gagal upload produk");
      }
    } catch (e) {
      showMsg("Koneksi ke server gagal");
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ==============================
  // BUILD UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe56484),
      appBar: AppBar(
        backgroundColor: const Color(0xffe56484),
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
              color: Colors.white,
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
                  onTap: pickImages,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: selectedImages.isEmpty
                        ? const Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Colors.grey,
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: selectedImages
                                .map(
                                  (img) => Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.file(img, height: 150),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Series",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    choiceSeries("One Piece", "onepiece"),
                    choiceSeries("JJK", "jjk"),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Kategori",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    choiceCategory("Nendoroid", "nendoroid"),
                    choiceCategory("Bags", "bags"),
                    choiceCategory("Figure", "figure"),
                  ],
                ),

                const SizedBox(height: 25),

                makeField("Nama Produk", nameController),
                const SizedBox(height: 16),
                makeField("Harga", priceController, type: TextInputType.number),
                const SizedBox(height: 16),
                makeField("Stok", stockController, type: TextInputType.number),
                const SizedBox(height: 16),
                makeField("Deskripsi", descController, lines: 4),
                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                    ),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
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
            fillColor: Colors.grey.shade200,
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
