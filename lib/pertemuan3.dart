import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormProdukPage(),
    );
  }
}

class FormProdukPage extends StatefulWidget {
  @override
  State<FormProdukPage> createState() => _FormProdukPageState();
}

class _FormProdukPageState extends State<FormProdukPage> {
  final TextEditingController kodeController =
      TextEditingController(text: "A001");

  final TextEditingController namaController =
      TextEditingController(text: "Keyboard");

  final TextEditingController hargaController =
      TextEditingController(text: "200000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFF7),
      appBar: AppBar(
        title: const Text("Aplikasi Flutter Pertama"),
        backgroundColor: Colors.blueGrey,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Form Produk",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 30),

            // Kode Produk
            TextField(
              controller: kodeController,
              decoration: const InputDecoration(
                labelText: "Kode Produk",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Nama Produk
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Produk",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // Harga Produk
            TextField(
              controller: hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Harga Produk",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProdukPage(
                        kode: kodeController.text,
                        nama: namaController.text,
                        harga: hargaController.text,
                      ),
                    ),
                  );
                },
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailProdukPage extends StatelessWidget {
  final String kode;
  final String nama;
  final String harga;

  const DetailProdukPage({
    super.key,
    required this.kode,
    required this.nama,
    required this.harga,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kode Produk : $kode",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 15),

            Text(
              "Nama Produk : $nama",
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 15),

            Text(
              "Harga Produk : $harga",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}