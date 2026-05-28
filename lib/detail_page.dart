import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String judul;

  DetailPage({required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          "Ini adalah isi dari $judul",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}