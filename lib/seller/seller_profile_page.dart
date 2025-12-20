import 'package:flutter/material.dart';
import 'package:otakushop/seller/user_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF88B7), // warna pink background
      body: SafeArea(
        child: Stack(
          children: [
            // MENU ICON
            Positioned(
              left: 16,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 30),
                onPressed: () {},
              ),
            ),

            // PROFILE ICON (kanan atas)
            Positioned(
              right: 16,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.person, size: 28, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage()),
                  );
                },
              ),
            ),

            // BACK BUTTON
            Positioned(
              left: 16,
              top: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(30, 30),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: Colors.red,
                ),
              ),
            ),

            // MAIN CONTENT
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Hi! Muhamad Lutfi",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Account Information",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // CARD LIST
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        infoTile("Lutfi"),
                        infoTile("Toko Lutfi"),
                        infoTile("History"),
                        infoTile("Alamat Toko"),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // IMAGE BOTTOM
                  Center(
                    child: SizedBox(
                      width: 180,
                      child: Image(image: AssetImage("assets/treasure.png")),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget
  static Widget infoTile(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      child: Text(
        text,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
