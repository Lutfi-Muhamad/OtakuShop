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
  List<File> selectedImages = [];

  final ImagePicker picker = ImagePicker();
  final SellerProductService productService = SellerProductService();

  // sementara (ambil dari database user nanti)
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
  // SERIES BOX
  // ==============================
  Widget choiceSeries(String title, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSeries = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selectedSeries == value ? Colors.pink : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedSeries == value ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // ==============================
  // SUBMIT
  // ==============================
  Future<void> submitProduct() async {
    // ================= VALIDASI =================
    if (selectedImages.isEmpty) {
      showMsg("Pilih minimal 1 foto");
      return;
    }

    if (selectedSeries == null) {
      showMsg("Pilih series produk terlebih dahulu");
      return;
    }

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        stockController.text.isEmpty ||
        descController.text.isEmpty) {
      showMsg("Isi semua form terlebih dahulu");
      return;
    }

    // ================= SUBMIT =================
    try {
      final result = await productService.createProduct(
        name: nameController.text,
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
                // ==============================
                // FOTO PRODUK
                // ==============================
                const Text(
                  "Foto Produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    height: 160,
                    width: double.infinity,
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(img, height: 150),
                                  ),
                                )
                                .toList(),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==============================
                // SERIES
                // ==============================
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

                // ==============================
                // INPUT FORM
                // ==============================
                makeField("Nama Produk", nameController),
                const SizedBox(height: 16),

                makeField("Harga", priceController, type: TextInputType.number),
                const SizedBox(height: 16),

                makeField("Stok", stockController, type: TextInputType.number),
                const SizedBox(height: 16),

                makeField("Deskripsi", descController, lines: 4),
                const SizedBox(height: 25),

                // ==============================
                // BUTTON CONFIRM
                // ==============================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitProduct, // ← WAJIB ADA INI!
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

  // ============================================================
  // WIDGET TEXT FIELD
  // ============================================================
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
