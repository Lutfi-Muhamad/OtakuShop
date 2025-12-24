import 'package:flutter/material.dart';
import 'dart:async';
import '../services/store_service.dart';
import '../services/auth_controller.dart';
import 'package:get/get.dart';
import 'seller_page.dart';

class SellerRegisterController extends GetxController {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  var loading = false.obs;

  Future<void> submitStore() async {
    loading.value = true;

    try {
      final result = await StoreService.registerStore(
        name: nameCtrl.text.trim(),
        phone: numberCtrl.text.trim(),
        address: addressCtrl.text.trim(),
      );

      // DEBUG UTAMA
      print("REGISTER STORE RESULT:");
      print(result);

      loading.value = false;

      // Timeout / error di service
      if (result["success"] == false && result.containsKey("error")) {
        print("ERROR TYPE: SERVICE / NETWORK");
        print("ERROR MESSAGE: ${result['error']}");

        Get.snackbar(
          "Gagal",
          result['error'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Sukses
      if (result["success"] == true) {
        print("REGISTER STORE SUCCESS");

        // 1. Refresh auth state (INI KUNCI)
        await Get.find<AuthController>().refreshUser();

        // 2. Pindah ke SellerPage
        Get.offAll(() => const SellerPage());

        return;
      }

      // Gagal dari backend (400 / 500)
      print("ERROR TYPE: BACKEND RESPONSE");
      print("STATUS / BODY: ${result['body']}");

      Get.snackbar(
        "Gagal",
        result['body'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e, stack) {
      loading.value = false;

      // ERROR YANG BENAR-BENAR GA KETANGKAP
      print("FATAL ERROR REGISTER STORE");
      print(e);
      print(stack);

      Get.snackbar(
        "Error",
        "Terjadi kesalahan tak terduga",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    numberCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }
}

class SellerRegisterPage extends StatelessWidget {
  const SellerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellerRegisterController());
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF57CA1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).appBarTheme.backgroundColor
            : const Color(0xFFF57CA1),
        title: const Text("Daftar Toko", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller.nameCtrl,
              decoration: InputDecoration(
                labelText: "Nama Toko",
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: controller.numberCtrl,
              decoration: InputDecoration(
                labelText: "Nomor Toko",
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: controller.addressCtrl,
              decoration: InputDecoration(
                labelText: "Alamat Toko",
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.pink
                      : Colors.white,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFFF57CA1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () =>
                    controller.loading.value ? null : controller.submitStore(),
                child: Obx(
                  () => Text(
                    controller.loading.value ? "Memuat..." : "Daftarkan Toko",
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
