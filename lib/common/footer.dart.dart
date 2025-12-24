import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Garis atas
          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 20),

          const Text(
            "Hubungi Kami di Sosial Media",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          // Row icon
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _iconBox(Icons.facebook),
              const SizedBox(width: 10),
              _iconBox(
                Icons.chat_bubble,
              ), // Ganti sendiri kalau mau pakai asset LINE
              const SizedBox(width: 10),
              _iconBox(Icons.camera_alt), // Instagram
              const SizedBox(width: 10),
              _iconBox(Icons.message), // Messenger
              const SizedBox(width: 10),
              _iconBox(Icons.phone),
            ],
          ),

          const SizedBox(height: 25),

          // Kontak telp
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.phone, size: 20, color: Colors.pink),
              SizedBox(width: 8),
              Text("0817 7009 2014"),
            ],
          ),

          const SizedBox(height: 12),

          // Kontak email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.email, size: 20, color: Colors.pink),
              SizedBox(width: 8),
              Text("otakushop@gmail.com"),
            ],
          ),

          const SizedBox(height: 25),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 25),

          // Logo dan tagline
          Column(
            children: const [
              Text(
                "Saingannya myAnimeList",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text("PArt PC lagi Mahal, Mainan Aja Dulu"),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "© sebelum masehi-2025 Untirta. All rights reserved.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Kotak icon sosial
  static Widget _iconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
