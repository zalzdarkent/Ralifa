<?php
include("./config.php");

// Mengatur header agar mengembalikan data dalam format JSON
header('Content-Type: application/json');

// Query untuk mengambil data dari tabel buku
$sql = "SELECT id, judul, penulis, tahun_terbit FROM buku";
$result = $koneksi->query($sql);

// Cek apakah ada hasil
if ($result->num_rows > 0) {
    $books = [];

    // Mengambil data dari hasil query
    while ($row = $result->fetch_assoc()) {
        $books[] = $row;
    }

    // Mengembalikan data dalam format JSON
    echo json_encode($books);
} else {
    // Jika tidak ada data, kembalikan array kosong
    echo json_encode([]);
}

// Menutup koneksi
$koneksi->close();
?>
