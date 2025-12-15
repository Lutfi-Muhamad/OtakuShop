import 'package:flutter/material.dart';
import 'package:otakushop/services/auth_controller.dart';
import 'register_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  void doLogin() async {
    setState(() => loading = true);

    final auth = Get.find<AuthController>();

    // ===== DEBUG START =====
    print('🔐 LOGIN PAGE');
    print('🔐 Auth instanceId = ${auth.instanceId}');
    print('🔐 token BEFORE login = "${auth.token.value}"');
    // ===== DEBUG END =====

    final success = await auth.login(email.text.trim(), password.text.trim());

    // ===== DEBUG START =====
    print('🔐 token AFTER login = "${auth.token.value}"');
    print('🔐 user AFTER login = ${auth.user.value}');
    // ===== DEBUG END =====

    setState(() => loading = false);

    if (success) {
      print('🔐 LOGIN SUCCESS → redirect to HOME');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Login Berhasil")));

      Get.offAllNamed('/');
    } else {
      print('🔐 LOGIN FAILED');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Login Gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: loading ? null : doLogin,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text("Daftar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
