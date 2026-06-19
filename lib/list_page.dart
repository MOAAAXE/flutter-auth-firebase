import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'pertemuan1.dart';
import 'pertemuan2.dart'; 
import 'pertemuan4.dart';
import 'pertemuan6.dart';
import 'pertemuan7.dart';
import 'pertemuan8.dart';
import 'pertemuan9.dart';
import 'pertemuan10.dart';

class ListPertemuanPage extends StatelessWidget {
  const ListPertemuanPage({super.key});

  final List<String> pertemuan = const [
    "Pertemuan 1",
    "Pertemuan 2",
    "Pertemuan 3",
    "Pertemuan 4",
    "Pertemuan 5",
    "Pertemuan 6",
    "Pertemuan 7",
    "Pertemuan 8",
    "Pertemuan 9",
    "Pertemuan 10",
  ];

  Widget _getPage(int index) {
    switch (index) {
      case 0: return Pertemuan1Page();
      case 1: return FormProdukPage();
      case 2: return FormProdukPage();
      case 3: return Pertemuan4Page();
      case 4: return DetailPage(judul: "Pertemuan 5");
      case 5: return const CheckboxPage();
      case 6: return const RadiobuttonPage();
      case 7: return AutocompletespinPage();
      case 8: return Pertemuan9Page();
      case 9: return AddProductScreen();
      default: return DetailPage(judul: "Halaman Tidak Ditemukan");
    }
  }

  // Fungsi untuk menampilkan Context Menu tepat di posisi koordinat klik/tap
  void _showContextMenu(BuildContext context, TapDownDetails details, int index) async {
    final position = details.globalPosition; // Mengambil koordinat posisi klik
    
    final result = await showMenu<String>(
      context: context,
      // Mengatur posisi munculnya menu di layar
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 1,
        position.dy + 1,
      ),
      items: [
        const PopupMenuItem<String>(
          value: 'buka',
          child: Text('Buka'),
        ),
        const PopupMenuItem<String>(
          value: 'detail',
          child: Text('Detail'),
        ),
        const PopupMenuItem<String>(
          value: 'hapus',
          child: Text('Hapus', style: TextStyle(color: Colors.red)),
        ),
      ],
    );

    // Aksi ketika item context menu dipilih (Sesuai Gambar 2)
    if (result != null && context.mounted) {
      if (result == 'buka') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => _getPage(index)));
      } else if (result == 'detail') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail Info ${pertemuan[index]}')),
        );
      } else if (result == 'hapus') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${pertemuan[index]} berhasil dihapus (simulasi)')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pertemuan.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5), // Warna background card agak abu-abu soft
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12.withOpacity(0.05)),
          ),
          child: GestureDetector(
            // FITUR CONTEXT MENU (Sesuai Gambar 2)
            // Mendeteksi Klik Kanan (Web/Desktop) atau Long Press (Mobile)
            onSecondaryTapDown: (details) => _showContextMenu(context, details, index), // Klik kanan
            onLongPressStart: (details) => _showContextMenu(context, TapDownDetails(globalPosition: details.globalPosition), index), // Tekan lama
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: const Color(0xffd1c4e9),
                child: Icon(Icons.dashboard_customize, color: Colors.purple[800]),
              ),
              title: Text(
                pertemuan[index],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: const Text("Materi Kuliah"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff673ab7)),
              onTap: () {
                // Klik biasa langsung buka halaman pertemuan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _getPage(index)),
                );
              },
            ),
          ),
        );
      },
    );
  }
}