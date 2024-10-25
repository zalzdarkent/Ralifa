import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddBook extends StatelessWidget {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _penulisController = TextEditingController();
  final TextEditingController _tahunTerbitController = TextEditingController();

  Future<void> addBook() async {
    final response = await http.post(
      Uri.parse('http://localhost/CRUD_API/create.php'), // Ganti dengan URL API Anda
      body: {
        'judul': _judulController.text,
        'penulis': _penulisController.text,
        'tahun_terbit': _tahunTerbitController.text,
      },
    );

    if (response.statusCode == 201) {
      print('Buku berhasil ditambahkan');
    } else {
      throw Exception('Gagal menambahkan buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: _penulisController,
              decoration: InputDecoration(labelText: 'Penulis'),
            ),
            TextField(
              controller: _tahunTerbitController,
              decoration: InputDecoration(labelText: 'Tahun Terbit'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addBook();
                Navigator.pop(context); // Kembali ke daftar buku
              },
              child: Text('Simpan Buku'),
            ),
          ],
        ),
      ),
    );
  }
}
