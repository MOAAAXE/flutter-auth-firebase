import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'pertemuan1.dart';
import 'pertemuan2.dart'; // pertemuan3.dart dihapus karena class-nya sama persis
import 'pertemuan4.dart';
import 'pertemuan6.dart';
import 'pertemuan7.dart';
import 'pertemuan8.dart';
import 'pertemuan9.dart';

class ListPertemuanPage extends StatelessWidget {
  final List<String> pertemuan = [
    "Pertemuan 1",
    "Pertemuan 2",
    "Pertemuan 3",
    "Pertemuan 4",
    "Pertemuan 5",
    "Pertemuan 6",
    "Pertemuan 7",
    "Pertemuan 8",
    "Pertemuan 9",
  ];

  // Mapping index → halaman tujuan
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return Pertemuan1Page();
      case 1:
        return FormProdukPage(); // dari pertemuan2.dart
      case 2:
        return FormProdukPage(); // pakai yang sama dari pertemuan2.dart
      case 3:
        return const Pertemuan4Page();
      case 4:
        // Pertemuan 5 belum ada isinya, pakai DetailPage dulu
        return DetailPage(judul: "Pertemuan 5");
      case 5:
        return const CheckboxPage(); // dari pertemuan6.dart
      case 6:
        return const RadiobuttonPage(); // dari pertemuan7.dart
      case 7:
        return AutocompletespinPage();
      case 8:
        return const Pertemuan9Page();
      default:
        return DetailPage(judul: pertemuan[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pertemuan.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(
                "${index + 1}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              pertemuan[index],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Materi pertemuan ${index + 1}"),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _getPage(index),
                ),
              );
            },
          ),
        );
      },
    );
  }
}