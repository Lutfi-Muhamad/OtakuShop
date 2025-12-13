import 'package:flutter/material.dart';
import 'package:otakushop/pages/home_page.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_controller.dart';


class logiclogin extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
Future<void> login() async {
  if (email.value.isEmpty || password.value.isEmpty) {
    Get.snackbar('Error', 'Email dan password harus diisi');
    return;
  }

  try {
    final payload = {'email': email.value, 'password': password.value};
    final response = await http.post(
      Uri.parse('${AuthController.baseUrl}/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      String namaUser = email.value;
      final auth = Get.put(AuthController(), permanent: true);
      try {
        final body = json.decode(response.body);
        if (body is Map) {
          final token =
              (body['access_token'] ?? body['token'] ?? body['data']?['token'])
                  ?.toString();
          if (token != null && token.isNotEmpty) {
            await auth.saveToken(token);
          }
        }
      } catch (_) {}
      auth.userName.value = namaUser;
      Get.snackbar('Sukses', 'Login berhasil, selamat datang $namaUser');
      Get.offAll(HomePage(), arguments: namaUser);
    } else {
      String msg = 'Login gagal. Status: ${response.statusCode}';
      try {
        final body = json.decode(response.body);
        if (body is Map && body.containsKey('message'))
          msg = body['message'].toString();
      } catch (_) {}
      Get.snackbar('Error', msg);
    }
  } catch (e) {
    Get.snackbar('Error', 'Gagal login: $e');
  }
}
}

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
    final success = await logiclogin(email.text, password.text);
    setState(() => loading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Login Berhasil")));
      Navigator.pushReplacementNamed(context, '/');
    } else {
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
              child: const Text("Login"),
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
