import 'package:flutter/material.dart';
import 'dart:async';
import '../services/store_service.dart';

class SellerRegisterPage extends StatefulWidget {
  const SellerRegisterPage({super.key});

  @override
  State<SellerRegisterPage> createState() => _SellerRegisterPageState();
}

class _SellerRegisterPageState extends State<SellerRegisterPage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  bool loading = false;

  Future<void> submitStore() async {
    setState(() => loading = true);

    try {
      final result = await StoreService.registerStore(
        name: nameCtrl.text.trim(),
        phone: numberCtrl.text.trim(),
        address: addressCtrl.text.trim(),
      );

      // DEBUG UTAMA
      print("REGISTER STORE RESULT:");
      print(result);

      setState(() => loading = false);

      // Timeout / error di service
      if (result["success"] == false && result.containsKey("error")) {
        print("ERROR TYPE: SERVICE / NETWORK");
        print("ERROR MESSAGE: ${result['error']}");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal: ${result['error']}")));
        return;
      }

      // Sukses
      if (result["success"] == true) {
        print("REGISTER STORE SUCCESS");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Toko berhasil didaftarkan!")),
        );
        Navigator.pop(context);
        return;
      }

      // Gagal dari backend (400 / 500)
      print("ERROR TYPE: BACKEND RESPONSE");
      print("STATUS / BODY: ${result['body']}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${result['body']}")));
    } catch (e, stack) {
      setState(() => loading = false);

      // ERROR YANG BENAR-BENAR GA KETANGKAP
      print("FATAL ERROR REGISTER STORE");
      print(e);
      print(stack);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan tak terduga")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF57CA1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF57CA1),
        title: const Text("Daftar Toko", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Nama Toko",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: numberCtrl,
              decoration: const InputDecoration(
                labelText: "Nomor Toko",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(
                labelText: "Alamat Toko",
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFF57CA1),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: loading ? null : submitStore,
                child: Text(
                  loading ? "Memuat..." : "Daftarkan Toko",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
