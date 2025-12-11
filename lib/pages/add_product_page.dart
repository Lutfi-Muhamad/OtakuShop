import 'package:flutter/material.dart';
import 'package:otakushop/pages/seller_profile_page.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= NAVBAR PINK =================
             Container(
  height: 70,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  color: Colors.pinkAccent,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // HAMBURGER
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 35, height: 5, color: Colors.red),
          const SizedBox(height: 5),
          Container(width: 35, height: 5, color: Colors.red),
          const SizedBox(height: 5),
          Container(width: 35, height: 5, color: Colors.red),
        ],
      ),

      // PROFIL — DIKLIK = PINDAH PAGE
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        },
        child: const Icon(Icons.person, color: Colors.black, size: 32),
      ),
    ],
  ),
),
              const SizedBox(height: 10),

              // ================= BACK BUTTON =================
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.lightBlue, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.red, size: 25),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= TITLE =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Tambah Barang",
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ================= CONTAINER UTAMA =================
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.pink.shade50,
                  border: Border.all(color: Colors.pinkAccent, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Masukan Foto Barang Disini",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black54),
                      ),
                      child: const Icon(Icons.camera_alt, size: 60, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // INPUT NAMA
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nama",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // KATEGORI TITLE
                    const Text(
                      "Pilih Kategori Barang",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // CATEGORY GRID
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                      children: [
                        categoryBox("Nendoroid", 80),
                        categoryBox("Action Figure", 15),
                        categoryBox("Backpack", 80),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // HARGA
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Masukan Harga Barang",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    // JUMLAH
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Jumlah Barang",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 20),

                    // DESKRIPSI
                    TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Deskripsi",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // BUTTON CONFIRM
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {},
                        child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // CATEGORY BOX
  Widget categoryBox(String title, int count) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              "https://i.imgur.com/rE9Y6LZ.jpeg",
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$title ($count)",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
