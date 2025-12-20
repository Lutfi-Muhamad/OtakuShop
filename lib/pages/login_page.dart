import 'package:flutter/material.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'register_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller text bisa ditaruh di dalam build untuk Stateless
    // atau dibuatkan controller terpisah seperti 'logiclogin' punyamu.
    // Untuk simpelnya, kita taruh sini saja tapi logic-nya pakai GetX.
    final email = TextEditingController();
    final password = TextEditingController();
    final auth = Get.find<AuthController>();

    // Variable reactive untuk loading (pengganti setState)
    final loading = false.obs;

    void doLogin() async {
      loading.value = true;
      final success = await auth.login(email.text.trim(), password.text.trim());
      loading.value = false;

      if (success) {
        Get.snackbar(
          "Sukses",
          "Login Berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/');
      } else {
        Get.snackbar(
          "Gagal",
          "Login Gagal, cek email/password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF87DAF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Text("Email", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(email),

              const SizedBox(height: 20),

              const Text("Password", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(password, isPassword: true),

              const SizedBox(height: 30),

              // Gunakan Obx untuk memantau perubahan loading
              Obx(
                () => Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: loading.value ? null : doLogin,
                    child: loading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(color: Colors.pink),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
