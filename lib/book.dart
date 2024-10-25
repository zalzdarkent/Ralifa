import 'package:flutter/material.dart';
import 'package:flutter_mysql/tambah.dart'; // Assuming you have an AddBook class
import 'package:flutter_mysql/edit.dart'; // Assuming you have an EditBook class for editing
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<dynamic> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'http://localhost/CRUD_API/ambil_data.php')); // Ganti dengan URL API Anda

    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> deleteBook(String id) async {
    final response = await http.post(
      Uri.parse('http://localhost/CRUD_API/delete.php'),
      body: {
        'id': id,
      },
    );

    if (response.statusCode == 200) {
      fetchBooks(); // Refresh the list after deletion
    } else {
      throw Exception('Failed to delete book');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Buku'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Judul')),
                DataColumn(label: Text('Penulis')),
                DataColumn(label: Text('Tahun Terbit')),
                DataColumn(label: Text('Aksi')), // Column for actions (edit and delete)
              ],
              rows: books.map((book) {
                return DataRow(cells: [
                  DataCell(Text(book['judul'])),
                  DataCell(Text(book['penulis'])),
                  DataCell(Text(book['tahun_terbit'])),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBook(
                                id: book['id'],
                                judul: book['judul'],
                                penulis: book['penulis'],
                                tahunTerbit: book['tahun_terbit'],
                              ),
                            ),
                          ).then((_) {
                            fetchBooks(); // Refresh the list after editing
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Confirm deletion dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Hapus Buku'),
                                content: Text('Apakah Anda yakin ingin menghapus buku ini?'),
                                actions: [
                                  TextButton(
                                    child: Text('Batal'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Hapus'),
                                    onPressed: () {
                                      deleteBook(book['id']); // Delete the book by its ID
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBook()),
                    ).then((_) {
                      fetchBooks(); // Refresh daftar buku setelah kembali dari halaman tambah buku
                    });
                  },
                  child: Text('Tambah Buku'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
