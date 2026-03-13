import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class EditServisPage extends StatefulWidget {
  final Map<String, dynamic> servis;

  const EditServisPage({super.key, required this.servis});

  @override
  State<EditServisPage> createState() => _EditServisPageState();
}

class _EditServisPageState extends State<EditServisPage> {
  final namaController = TextEditingController();
  final tipeController = TextEditingController();
  final keluhanController = TextEditingController();

  @override
  void initState() {
    super.initState();

    namaController.text = widget.servis["nama_pelanggan"];
    tipeController.text = widget.servis["tipe_motor"];
    keluhanController.text = widget.servis["keluhan"];
  }

  Future<void> updateData() async {
    await supabase.from('servis').update({
      'nama_pelanggan': namaController.text,
      'tipe_motor': tipeController.text,
      'keluhan': keluhanController.text,
    }).eq('id', widget.servis['id']);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose () {
    namaController.dispose();
    tipeController.dispose();
    keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Data Servis",
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 8, 13, 67),
                Color.fromARGB(255, 17, 27, 137),
                Color.fromARGB(255, 43, 59, 230),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Pelanggan",
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tipeController,
              decoration: const InputDecoration(
                labelText: "Tipe Motor",
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keluhanController,
              decoration: const InputDecoration(
                labelText: "Keluhan",
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateData,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}