import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ==========================================
// 0. MODEL PRODUCT
// ==========================================
class Product {
  final String id;
  final String name;
  final String descriptions;
  final int price;
  final int stock;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.descriptions,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      descriptions: json['descriptions'] ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'descriptions': descriptions,
        'price': price,
        'stock': stock,
        'imageUrl': imageUrl ?? '',
      };
}

// ==========================================
// 1. API SERVICE SECTION
// ==========================================
class ApiService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final CollectionReference _productsRef =
      _firestore.collection('products');

  static const Duration _defaultTimeout = Duration(seconds: 30);

  // Stream untuk pembaruan data secara Real-time ke UI Dashboard
  static Stream<List<Product>> getProductsStream() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    });
  }

  static Future<Product> createProduct({
    required String name,
    required String descriptions,
    required int price,
    required int stock,
  }) async {
    try {
      debugPrint('[ApiService] createProduct: start');
      final docRef = _productsRef.doc();

      final Map<String, dynamic> productData = {
        'name': name,
        'descriptions': descriptions,
        'price': price,
        'stock': stock,
        'imageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      };

      await docRef.set(productData).timeout(_defaultTimeout);
      productData['id'] = docRef.id;
      debugPrint('[ApiService] createProduct: success id=${docRef.id}');
      return Product.fromJson(productData);
    } on TimeoutException {
      throw Exception('Timeout: Firestore tidak merespon saat membuat produk.');
    } catch (e) {
      throw Exception('Error createProduct Firebase: $e');
    }
  }

  static Future<Product> updateProduct({
    required String id,
    required String name,
    required String descriptions,
    required int price,
    required int stock,
  }) async {
    try {
      debugPrint('[ApiService] updateProduct: start id=$id');
      final docRef = _productsRef.doc(id);

      await docRef.update({
        'name': name,
        'descriptions': descriptions,
        'price': price,
        'stock': stock,
        'updatedAt': FieldValue.serverTimestamp(),
      }).timeout(_defaultTimeout);

      final snapshot = await docRef.get().timeout(_defaultTimeout);
      final data = snapshot.data() as Map<String, dynamic>;
      data['id'] = id;
      return Product.fromJson(data);
    } on TimeoutException {
      throw Exception('Timeout: Firestore tidak merespon saat update produk.');
    } catch (e) {
      throw Exception('Error updateProduct Firebase: $e');
    }
  }

  static Future<String> uploadImageBytes(
    String id,
    Uint8List bytes,
    String filename, {
    String contentType = 'image/jpeg',
  }) async {
    try {
      debugPrint('[ApiService] uploadImageBytes: start id=$id file=$filename');
      final ref = _storage.ref().child('products/$id/$filename');
      final metadata = SettableMetadata(contentType: contentType);

      final uploadTask = await ref
          .putData(bytes, metadata)
          .timeout(const Duration(seconds: 60));

      final String downloadUrl = await uploadTask.ref
          .getDownloadURL()
          .timeout(_defaultTimeout);

      await _productsRef
          .doc(id)
          .update({'imageUrl': downloadUrl}).timeout(_defaultTimeout);

      return downloadUrl;
    } on TimeoutException {
      throw Exception('Timeout: Upload gambar terlalu lama.');
    } catch (e) {
      throw Exception('Error uploadImageBytes Firebase: $e');
    }
  }

  static Future<void> _deleteProductImage(String id) async {
    try {
      final ListResult result =
          await _storage.ref().child('products/$id').listAll();
      for (final item in result.items) {
        await item.delete();
      }
    } catch (e) {
      debugPrint('Info: tidak ada gambar untuk dihapus di Storage: $e');
    }
  }

  static Future<bool> deleteProduct(String id) async {
    try {
      await _deleteProductImage(id);
      await _productsRef.doc(id).delete().timeout(_defaultTimeout);
      return true;
    } catch (e) {
      throw Exception('Error deleteProduct Firebase: $e');
    }
  }
}

// ==========================================
// 2. MAIN DASHBOARD SCREEN (HALAMAN AWAL)
// ==========================================
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
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Membuka $value')),
              );
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'Profil', child: Text('Profil')),
              const PopupMenuItem(value: 'Tentang Aplikasi', child: Text('Tentang Aplikasi')),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Ungu Grafis Informasi
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
                  child: Icon(Icons.shopping_bag, color: Colors.purple[800]),
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
                      'Dashboard Katalog Produk',
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
              'Daftar Produk Terkini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff673ab7)),
            ),
          ),
          // List Produk Real-time dari Firebase StreamBuilder
          const Expanded(
            child: ListPertemuanPage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke halaman form tambah produk
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        label: const Text('Tambah Produk', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xff673ab7),
      ),
    );
  }
}

// ==========================================
// 3. REAL-TIME LIST VIEW COMPONENT
// ==========================================
class ListPertemuanPage extends StatelessWidget {
  const ListPertemuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: ApiService.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final produkList = snapshot.data ?? [];

        if (produkList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Belum ada produk. Silakan klik + Tambah Produk!', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: produkList.length,
          itemBuilder: (context, index) {
            final produk = produkList[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tampilan Gambar Produk
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: produk.imageUrl != null && produk.imageUrl!.isNotEmpty
                          ? Image.network(
                              produk.imageUrl!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 16),
                    // Detail Teks Informasi
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produk.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            produk.descriptions,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[500],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Rp ${produk.price}',
                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Stok: ${produk.stock}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tombol Aksi (Edit & Delete)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 22),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddProductScreen(product: produk),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                          onPressed: () async {
                            final konfirmasi = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Hapus Produk'),
                                content: Text('Apakah kamu yakin ingin menghapus ${produk.name}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
                                ],
                              ),
                            );
                            if (konfirmasi == true) {
                              await ApiService.deleteProduct(produk.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ==========================================
// 4. UI SCREEN (Add / Edit Form Screen)
// ==========================================
class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  XFile? _imageXFile;
  Uint8List? _webImageBytes;
  Uint8List? _mobileImageBytes;
  String _webImageFilename = 'image.jpg';
  bool _isLoading = false;
  bool _isImageChanged = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.descriptions;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;

      if (kIsWeb) {
        setState(() {
          _webImageBytes = bytes;
          _webImageFilename = image.name;
          _imageXFile = null;
          _mobileImageBytes = null;
          _isImageChanged = true;
        });
      } else {
        setState(() {
          _mobileImageBytes = bytes;
          _imageXFile = image;
          _webImageBytes = null;
          _isImageChanged = true;
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih gambar: $e', Colors.red);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;
      setState(() {
        _mobileImageBytes = bytes;
        _imageXFile = image;
        _webImageBytes = null;
        _isImageChanged = true;
      });
    } catch (e) {
      _showSnackBar('Gagal mengambil foto: $e', Colors.red);
    }
  }

  void _removeImage() {
    setState(() {
      _imageXFile = null;
      _webImageBytes = null;
      _mobileImageBytes = null;
      _isImageChanged = true;
    });
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(_webImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    if (!kIsWeb && _mobileImageBytes != null) {
      return Image.memory(_mobileImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    if (!_isImageChanged && widget.product?.imageUrl != null && widget.product!.imageUrl!.isNotEmpty) {
      return Image.network(widget.product!.imageUrl!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text('Tap untuk pilih gambar', style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  void _showImagePickerDialog() {
    final bool hasImage = _webImageBytes != null || _mobileImageBytes != null || (widget.product?.imageUrl != null && widget.product!.imageUrl!.isNotEmpty && !_isImageChanged);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blue),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            if (hasImage)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus Gambar', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final int price = int.parse(_priceController.text);
      final int stock = int.parse(_stockController.text);
      final String descriptions = _descriptionController.text.trim();

      if (widget.product == null) {
        final newProduct = await ApiService.createProduct(
          name: _nameController.text.trim(),
          descriptions: descriptions,
          price: price,
          stock: stock,
        );

        try {
          if (kIsWeb && _webImageBytes != null) {
            await ApiService.uploadImageBytes(newProduct.id, _webImageBytes!, _webImageFilename);
          } else if (!kIsWeb && _mobileImageBytes != null) {
            final filename = _imageXFile?.name ?? 'image.jpg';
            await ApiService.uploadImageBytes(newProduct.id, _mobileImageBytes!, filename);
          }
        } catch (uploadErr) {
          _showSnackBar('Produk disimpan, gambar gagal diupload', Colors.orange);
          if (mounted) Navigator.pop(context);
          return;
        }

        if (mounted) {
          _showSnackBar('Produk berhasil ditambahkan', Colors.green);
          Navigator.pop(context);
        }
      } else {
        await ApiService.updateProduct(
          id: widget.product!.id,
          name: _nameController.text.trim(),
          descriptions: descriptions,
          price: price,
          stock: stock,
        );

        if (_isImageChanged) {
          try {
            if (kIsWeb && _webImageBytes != null) {
              await ApiService.uploadImageBytes(widget.product!.id, _webImageBytes!, _webImageFilename);
            } else if (!kIsWeb && _mobileImageBytes != null) {
              final filename = _imageXFile?.name ?? 'image.jpg';
              await ApiService.uploadImageBytes(widget.product!.id, _mobileImageBytes!, filename);
            }
          } catch (uploadErr) {
            _showSnackBar('Produk diperbarui, gambar gagal diupload', Colors.orange);
            if (mounted) Navigator.pop(context);
            return;
          }
        }

        if (mounted) {
          _showSnackBar('Produk berhasil diperbarui', Colors.green);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showSnackBar('Gagal menyimpan produk: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
        backgroundColor: const Color(0xff673ab7),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: _isLoading ? null : _showImagePickerDialog,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _buildImagePreview(),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.edit, color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'Nama Produk *', border: OutlineInputBorder()),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isLoading,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harga *', prefixText: 'Rp ', border: OutlineInputBorder()),
                  validator: (v) => v == null || int.tryParse(v) == null ? 'Masukkan harga valid' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _stockController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stok *', border: OutlineInputBorder()),
                  validator: (v) => v == null || int.tryParse(v) == null ? 'Masukkan stok valid' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff673ab7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(widget.product == null ? 'Simpan Produk' : 'Update Produk'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}