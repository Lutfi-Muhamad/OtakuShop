import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_controller.dart';
import 'package:otakushop/models/user.dart';
import 'package:get/get.dart';

class ProfileEditPage extends StatefulWidget {
  final User user;
  const ProfileEditPage({super.key, required this.user});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController nameC;
  late TextEditingController bioC;
  late TextEditingController addressC;

  File? photoFile;
  final AuthController _auth = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    nameC = TextEditingController(text: widget.user.name);
    bioC = TextEditingController(text: widget.user.bio);
    addressC = TextEditingController(text: widget.user.address);
  }

  Future pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        photoFile = File(picked.path);
      });
    }
  }

  Future saveProfile() async {
    final ok = await _auth.updateProfile(
      name: nameC.text,
      bio: bioC.text,
      address: addressC.text,
      photoFile: photoFile,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? "Profil berhasil diupdate" : "Gagal update profil"),
      ),
    );

    if (ok) {
      Navigator.pop(context, true); // kembali + refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickPhoto,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: photoFile != null
                    ? FileImage(photoFile!)
                    : (widget.user.photo != null
                          ? NetworkImage(widget.user.photo!)
                          : null),
                child: (photoFile == null && widget.user.photo == null)
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: bioC,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: addressC,
              decoration: const InputDecoration(labelText: "Alamat"),
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: saveProfile, child: const Text("Simpan")),
          ],
        ),
      ),
    );
  }
}
