<?php
include("./config.php");

// Cek apakah request method adalah POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil data dari request
    $judul = $_POST['judul'] ?? '';
    $penulis = $_POST['penulis'] ?? '';
    $tahun_terbit = $_POST['tahun_terbit'] ?? '';

    // Validasi input
    if (empty($judul) || empty($penulis) || empty($tahun_terbit)) {
        http_response_code(400);
        echo json_encode(['message' => 'Semua field harus diisi']);
        exit;
    }

    // Query untuk menyimpan data ke database
    $sql = "INSERT INTO buku (judul, penulis, tahun_terbit) VALUES (?, ?, ?)";
    $stmt = $koneksi->prepare($sql);
    
    // Bind dan execute
    $stmt->bind_param("ssi", $judul, $penulis, $tahun_terbit);
    
    if ($stmt->execute()) {
        http_response_code(201);
        echo json_encode(['message' => 'Data berhasil disimpan']);
    } else {
        http_response_code(500);
        echo json_encode(['message' => 'Terjadi kesalahan saat menyimpan data']);
    }

    // Tutup statement
    $stmt->close();
} else {
    // Jika bukan POST, kirim status 405 Method Not Allowed
    http_response_code(405);
    echo json_encode(['message' => 'Metode tidak diizinkan']);
}

// Tutup koneksi
$koneksi->close();
?>
