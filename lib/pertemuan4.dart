import 'package:flutter/material.dart';

class Pertemuan4Page extends StatelessWidget {
  const Pertemuan4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EFF7),

      appBar: AppBar(
        title: const Text("Pertemuan 4"),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // BUTTON SUBMIT
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil disubmit"),
                  ),
                );
              },
              child: const Text("Submit"),
            ),

            const SizedBox(height: 10),

            // BUTTON DELETE
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil dihapus"),
                  ),
                );
              },
              child: const Text("Delete"),
            ),

            const SizedBox(height: 10),

            // BUTTON DIALOG
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Dialog"),
                      content: const Text(
                        "Ini adalah contoh Alert Dialog",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Show Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}