import 'package:flutter/material.dart';
import 'package:otakushop/pages/edit_seller_page.dart';
import 'package:otakushop/pages/home_page.dart';
import 'package:otakushop/pages/seller_profile_page.dart';
import 'package:otakushop/pages/user_profile_page.dart';
import 'add_product_page.dart';

// TAMBAHKAN HALAMAN YANG LO TUJU
import 'package:otakushop/pages/home_page.dart';

import 'package:otakushop/pages/edit_seller_page.dart';
// import 'delete_seller_page.dart';

class SellerPage extends StatelessWidget {
  const SellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              //      TOP NAVBAR
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
                          MaterialPageRoute(
                            builder: (_) => const ProfilePage(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // =========================
              // BACK BUTTON + SEARCH
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // BACK TO HOME
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.pinkAccent,
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              //        TITLE
              // =========================
              const Center(
                child: Text(
                  "My Products",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              //      PRODUCT GRID
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                  children: [
                    productCard(
                      context,
                      "Gojo Satoru – Nendoroid Original Flash Order",
                      "IDR 500.000",
                      "https://i.imgur.com/rE9Y6LZ.jpeg",
                    ),

                    productCard(
                      context,
                      "Nami – Nendoroid Original Flash Order",
                      "IDR 500.000",
                      "https://i.imgur.com/w1FQ5kG.jpeg",
                    ),

                    placeholderBox(),
                    placeholderBox(),
                    placeholderBox(),
                    placeholderBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================
      //     FLOATING BUTTON
      // =========================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductPage()),
          );
        },
        child: const Icon(Icons.add, size: 35, color: Colors.white),
      ),
    );
  }

  // ==========================================================
  //                PRODUCT CARD (TELAH DITAMBAH EDIT/DELETE)
  // ==========================================================
  Widget productCard(
    BuildContext context,
    String title,
    String price,
    String imgUrl,
  ) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imgUrl, height: 120, fit: BoxFit.cover),
        ),
        const SizedBox(height: 6),

        // LIMITED + EDIT + DELETE
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LIMITED TAG
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Limited",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

            const SizedBox(width: 6),

            // EDIT
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditSellerPage()),
                );
              },
              child: const Icon(Icons.edit, size: 18, color: Colors.blue),
            ),

            const SizedBox(width: 8),

            // // DELETE
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Yakin ingin menghapus?\nTindakan ini tidak bisa dibatalkan",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // BATAL
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  color: Colors.green,
                                  child: const Center(
                                    child: Text(
                                      "BATAL",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // IYA
                            Expanded(
                              child: GestureDetector(
                                // onTap: () {
                                //   Navigator.pop(context);
                                //   de(); // Panggil fungsi hapus
                                // },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  color: Colors.red,
                                  child: const Center(
                                    child: Text(
                                      "IYA",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(Icons.delete, size: 18, color: Colors.red),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // TITLE
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 6),

        // PRICE
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // =========================
  //   EMPTY PRODUCT SLOT
  // =========================
  Widget placeholderBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
