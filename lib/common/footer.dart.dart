import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Garis atas
          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 20),

          const Text(
            "Interact with Kyou",
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
              Text("e-support@kyou.id"),
            ],
          ),

          const SizedBox(height: 25),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 25),

          // Logo dan tagline
          Column(
            children: const [
              Text(
                "Kyōu.id",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 8),
              Text("Ayo cintai hobimu bareng Kyou!"),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "© 2014–2025 Kyou Hobby Shop",
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
