import 'package:flutter/material.dart';
import 'package:strivio/widgets/left_drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:strivio/screens/menu.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  double _price = 0;
  String _description = "";
  String _category = "Gear";
  String _thumbnail = "";
  double _rating = 5; 
  int _stock = 1;

  final List<String> _categories = [
    'Gear',
    'Clothing',
    'Shoes',
    'Accessory',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Tambah Produk Baru')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Name ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Nama Produk",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (value) => setState(() => _name = value),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Nama tidak boleh kosong!" : null,
                ),
              ),

              // === Price ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Harga (Rp)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => _price = double.tryParse(value) ?? 0);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harga tidak boleh kosong!";
                    } else if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return "Harga harus berupa angka positif!";
                    }
                    return null;
                  },
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Deskripsi Produk",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (value) => setState(() => _description = value),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Deskripsi tidak boleh kosong!" : null,
                ),
              ),

              // === Category ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  value: _category,
                  items: _categories
                      .map((cat) =>
                          DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (newValue) => setState(() => _category = newValue!),
                ),
              ),

              // === Thumbnail URL ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "URL Gambar Produk (opsional)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  onChanged: (value) => setState(() => _thumbnail = value),
                  validator: (value) {
                    if (value!.isNotEmpty &&
                        !Uri.parse(value).isAbsolute) {
                      return "Masukkan URL yang valid!";
                    }
                    return null;
                  },
                ),
              ),

              // === Rating ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Rating Produk"),
                    Slider(
                      value: _rating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _rating.toString(),
                      onChanged: (value) => setState(() => _rating = value),
                    ),
                  ],
                ),
              ),

              // === Stock ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Stok",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() => _stock = int.tryParse(value) ?? 0);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Stok tidak boleh kosong!";
                    } else if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return "Stok harus lebih dari 0!";
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        "http://localhost:8000/create-flutter/",
                        jsonEncode({
                          "name": _name,
                          "price": _price,
                          "description": _description,
                          "thumbnail": _thumbnail,
                          "category": _category,
                          "rating": _rating,       
                          "stock": _stock,       
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Product successfully saved!")),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Something went wrong, please try again."),
                            ),
                          );
                        }
                      }
                    }
                  },
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
