import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_controller.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    final auth = Get.find<AuthController>();

    // Reactive variable pengganti setState
    final loading = false.obs;

    void doRegister() async {
      if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
        Get.snackbar(
          "Error",
          "Semua field harus diisi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      loading.value = true;
      final success = await auth.register(name.text, email.text, password.text);
      loading.value = false;

      if (success) {
        // Refresh user atau langsung ke login
        await auth.refreshUser();

        Get.snackbar(
          "Sukses",
          "Register Berhasil!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/login'); // langsung ke halaman login
      } else {
        Get.snackbar(
          "Gagal",
          "Register Gagal",
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
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              const Text("Name", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(name),

              const SizedBox(height: 20),

              const Text("Email", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(email),

              const SizedBox(height: 20),

              const Text("Password", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 6),
              _input(password, isPassword: true),

              const SizedBox(height: 30),

              Obx(
                () => Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: loading.value ? null : doRegister,
                    child: loading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Create Account",
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
                    "Sudah punya akun?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Login",
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
