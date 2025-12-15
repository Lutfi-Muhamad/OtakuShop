import 'package:flutter/material.dart';
import 'package:otakushop/seller/seller_profile_page.dart';
// import 'seller_page.dart';
// import 'user_profile_page.dart';

class EditSellerPage extends StatelessWidget {
  const EditSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF88B7),
      body: SafeArea(
        child: Stack(
          children: [
            // =========================
            //          NAVBAR
            // =========================
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.pinkAccent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, color: Colors.black, size: 30),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfilePage()),
                      );
                    },
                    child: const Icon(Icons.person, color: Colors.black, size: 30),
                  ),
                ],
              ),
            ),

            // =========================
            //     MAIN CONTENT
            // =========================
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Center(
                child: Container(
                  width: 330,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // =========================
                      //      IMAGE PREVIEW
                      // =========================
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://i.imgur.com/rE9Y6LZ.jpeg",
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          Positioned.fill(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.photo_camera,
                                    size: 40, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // =========================
                      //      LIMITED TAG
                      // =========================
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Limited",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // =========================
                      //      FORM INPUT
                      // =========================
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Nama", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Harga", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Dekripsi", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          maxLines: null,
                          decoration:
                              InputDecoration(border: InputBorder.none),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      //      BUTTON SAVE
                      // =========================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Simpan Perubahan",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
}