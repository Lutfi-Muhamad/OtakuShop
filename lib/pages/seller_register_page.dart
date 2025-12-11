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

    final result = await StoreService.registerStore(
      name: nameCtrl.text.trim(),
      phone: numberCtrl.text.trim(),
      address: addressCtrl.text.trim(),
    );

    setState(() => loading = false);

    // Timeout atau gagal request
    if (result["success"] == false && result.containsKey("error")) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: ${result['error']}")));
      return;
    }

    // Respons sukses (200/201)
    if (result["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Toko berhasil didaftarkan!")),
      );
      Navigator.pop(context);
      return;
    }

    // Respons gagal dari server (status 400 / 500)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Gagal: ${result['body']}")));
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
