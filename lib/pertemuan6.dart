import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key}); // FIX 1: tambah const constructor + super.key

  @override
  State<CheckboxPage> createState() => _CheckboxPageState(); // FIX 2: nama class diubah sesuai konvensi
}

class _CheckboxPageState extends State<CheckboxPage> {
  // Form controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _kelasController = TextEditingController();

  // Checkbox states
  bool _isCheckedSyarat = false;

  // FIX 3: nama variabel disamakan (_errorText → _syaratError) agar konsisten
  String _syaratError = '';

  // Hobby checkboxes
  final Map<String, bool> _hobbies = {
    'Membaca': false,
    'Olahraga': false,
    'Musik': false,
    'Game': false,
    'Traveling': false,
  };

  // Form validation errors
  String _namaError = '';
  String _nimError = '';
  String _kelasError = '';
  String _hobbyError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent,
        title: const Text( // FIX 4: tambah const
          'Form dengan Checkbox',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        shape: const RoundedRectangleBorder( // FIX 4: tambah const
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(24),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding( // FIX 5: Container hanya untuk padding → pakai Padding
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Bagian Data Diri ──────────────────────────────────────────
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding( // FIX 5: Container hanya padding → Padding
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Data Diri',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Field Nama
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',
                          hintText: 'Masukkan nama lengkap Anda',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: _namaError.isNotEmpty ? _namaError : null,
                          prefixIcon:
                              Icon(Icons.person_outline, color: Colors.blue.shade600),
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Field NIM
                      TextField(
                        controller: _nimController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'NIM',
                          hintText: 'Masukkan NIM Anda',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: _nimError.isNotEmpty ? _nimError : null,
                          prefixIcon:
                              Icon(Icons.numbers, color: Colors.blue.shade600),
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Field Kelas
                      TextField(
                        controller: _kelasController,
                        decoration: InputDecoration(
                          labelText: 'Kelas',
                          hintText: 'Contoh: 01SIFP001',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorText: _kelasError.isNotEmpty ? _kelasError : null,
                          prefixIcon:
                              Icon(Icons.class_, color: Colors.blue.shade600),
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Bagian Hobi ───────────────────────────────────────────────
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade600,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Hobi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(Pilih minimal 1)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // FIX 6: GridView diganti Wrap agar item ke-5 tidak
                      // menggantung sendirian & tidak butuh height tetap
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade50,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Wrap(
                          children: _hobbies.keys.map((hobby) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 40,
                              child: CheckboxListTile(
                                title: Text(
                                  hobby,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: _hobbies[hobby],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _hobbies[hobby] = value ?? false;
                                    if (_hobbies.values.any((v) => v)) {
                                      _hobbyError = '';
                                    }
                                  });
                                },
                                activeColor: Colors.orange.shade600,
                                checkColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      if (_hobbyError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.warning, size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                _hobbyError,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Syarat dan Ketentuan ──────────────────────────────────────
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text( // FIX 4: const
                          'Saya menyetujui syarat dan ketentuan yang berlaku',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: _isCheckedSyarat,
                        onChanged: (bool? value) {
                          setState(() {
                            _isCheckedSyarat = value ?? false;
                            if (_isCheckedSyarat) _syaratError = ''; // FIX 3
                          });
                        },
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_syaratError.isNotEmpty) // FIX 3
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.warning,
                                  size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                _syaratError, // FIX 3
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FIX 7: Container diganti SizedBox (lebih semantik untuk sizing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _validateAndSubmit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'DAFTAR SEKARANG',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit(BuildContext context) {
    setState(() {
      // Reset semua error
      _namaError = '';
      _nimError = '';
      _kelasError = '';
      _hobbyError = '';
      _syaratError = ''; // FIX 3

      // Validasi Nama
      if (_namaController.text.trim().isEmpty) {
        _namaError = 'Nama tidak boleh kosong';
      }

      // Validasi NIM
      if (_nimController.text.trim().isEmpty) {
        _nimError = 'NIM tidak boleh kosong';
      } else if (_nimController.text.trim().length < 8) {
        _nimError = 'NIM minimal 8 karakter';
      }

      // Validasi Kelas
      if (_kelasController.text.trim().isEmpty) {
        _kelasError = 'Kelas tidak boleh kosong';
      }

      // Validasi Hobi (minimal 1)
      if (!_hobbies.values.any((selected) => selected)) {
        _hobbyError = 'Pilih minimal 1 hobi';
      }

      // Validasi Syarat
      if (!_isCheckedSyarat) {
        _syaratError = 'Anda harus menyetujui syarat dan ketentuan'; // FIX 3
      }

      // Jika semua validasi lolos
      if (_namaError.isEmpty &&
          _nimError.isEmpty &&
          _kelasError.isEmpty &&
          _hobbyError.isEmpty &&
          _isCheckedSyarat) {
        final List<String> selectedHobbies = _hobbies.keys
            .where((hobby) => _hobbies[hobby] == true)
            .toList();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding( // FIX 5: Container → Padding
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pendaftaran Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // FIX 8: bungkus dengan ConstrainedBox agar teks panjang
                  // tidak overflow di layar kecil
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(Icons.person, 'Nama',
                            _namaController.text),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.numbers, 'NIM',
                            _nimController.text),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.class_, 'Kelas',
                            _kelasController.text),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.favorite, 'Hobi',
                            selectedHobbies.join(', ')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetForm();
                      Fluttertoast.showToast(
                        msg: 'Pendaftaran Berhasil Disimpan!!',
                        gravity: ToastGravity.TOP,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('OK', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 12),
        // FIX 9: bungkus Flexible agar teks panjang tidak overflow
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _nimController.clear();
      _kelasController.clear();
      _hobbies.updateAll((key, value) => false);
      _isCheckedSyarat = false;
      _namaError = '';
      _nimError = '';
      _kelasError = '';
      _hobbyError = '';
      _syaratError = ''; // FIX 3
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _kelasController.dispose();
    super.dispose();
  }
}