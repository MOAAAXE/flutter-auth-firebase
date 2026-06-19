import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/auth/auth_page.dart';
// Import file pertemuan10.dart agar bisa membaca Katalog Produk
import '../pertemuan10.dart' as p10; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff673ab7), 
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'profil') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Profil')),
                );
              } else if (value == 'tentang') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka Tentang Aplikasi')),
                );
              } else if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'profil',
                child: Text('Profil'),
              ),
              const PopupMenuItem<String>(
                value: 'tentang',
                child: Text('Tentang Aplikasi'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Mobile Programming (Ungu)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff673ab7), Color(0xff9c27b0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 24,
                  child: Icon(Icons.logout, color: Colors.purple[800]),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mobile Programming',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Dashboard Pertemuan',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Daftar Pertemuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff673ab7)),
            ),
          ),
          // List Pertemuan Halaman (1 - 10)
          const Expanded(
            child: ListPertemuanPage(),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// COMPONENT LIST PERTEMUAN (1 Sampai 10)
// ==========================================
class ListPertemuanPage extends StatelessWidget {
  const ListPertemuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate otomatis list 'Pertemuan 1' sampai 'Pertemuan 10'
    final List<String> daftarPertemuan = List.generate(10, (index) => 'Pertemuan ${index + 1}');

    return ListView.builder(
      itemCount: daftarPertemuan.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final title = daftarPertemuan[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xfff5f5f5),
          elevation: 0,
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffe1dee9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.grid_view_rounded, color: Color(0xff673ab7)),
            ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Materi Kuliah'),
            trailing: const Icon(Icons.chevron_right, color: Color(0xff673ab7)),
            onTap: () {
              if (title == 'Pertemuan 10') {
                // Ketika Pertemuan 10 diklik, arahkan ke Katalog Produk di pertemuan10.dart
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const p10.HomePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Halaman $title belum diimplementasikan')),
                );
              }
            },
          ),
        );
      },
    );
  }
}