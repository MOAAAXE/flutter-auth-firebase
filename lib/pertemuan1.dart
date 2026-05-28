import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Pertemuan1Page extends StatelessWidget {

  final Uri youtubeUrl = Uri.parse(
    'https://www.youtube.com/watch?v=4senIJ6TU_o&t=182s',
  );

  Future<void> bukaYoutube() async {
    if (!await launchUrl(
      youtubeUrl,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Tidak bisa membuka link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pertemuan 1"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: bukaYoutube,
          child: Text("Buka Video YouTube"),
        ),
      ),
    );
  }
}