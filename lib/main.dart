import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/home_page.dart';

void main() async {
  // 1. Pastikan binding Flutter selesai diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Inisialisasi Firebase dengan proteksi try-catch
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    

    debugPrint("Firebase berhasil terkoneksi!");
  } catch (e) {
    debugPrint("Gagal inisialisasi Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pertemuan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Tambahkan properti home di bawah ini
      home: const HomePage(), 
    );
  }
}