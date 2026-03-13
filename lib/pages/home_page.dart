import 'package:flutter/material.dart';
import 'tambah_servis_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_servis_page.dart';
import '../main.dart';
import 'login_page.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Map<String, dynamic>>> getServis() async {
    final response = await supabase.from('servis').select();
    return response;
  }

  void bukaFormTambah() async {
  final hasil = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const TambahServisPage(),
    ),
  );

    if (hasil != null) {
    setState(() {});
  }
}

void bukaFormEdit(Map<String, dynamic> servis) async {
  final hasil = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditServisPage(servis: servis),
    ),
  );

  if (hasil != null) {
    setState(() {});
  }
}

Future<void> hapusServis(int id) async {
  await supabase
      .from('servis')
      .delete()
      .eq('id', id);

  setState(() {});
}

Future<void> logout() async {
  final confirm = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text("Logout"),
          ],
        ),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Batal"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Logout"),
          ),

        ],
      );
    },
  );

  if (confirm == true) {
    await supabase.auth.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bengkel DMR Samarinda",
          style: TextStyle(color: Colors.white),
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),

          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              BengkelApp.of(context).toggleTheme();
            },
          ),
        ],
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getServis(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(
              child: Text("Belum ada data servis"),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final servis = data[index];

              return Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(servis["nama_pelanggan"]),
                  subtitle: Text(
                    "${servis['tipe_motor']} - ${servis['keluhan']}",
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          bukaFormEdit(servis);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          hapusServis(servis['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bukaFormTambah,
        child: const Icon(Icons.add),
      ),
    );
  }
}