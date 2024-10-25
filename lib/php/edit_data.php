<?php
include("./config.php");

// Cek apakah request method adalah POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil data dari request
    $id = $_POST['id'] ?? '';
    $judul = $_POST['judul'] ?? '';
    $penulis = $_POST['penulis'] ?? '';
    $tahun_terbit = $_POST['tahun_terbit'] ?? '';

    // Validasi input
    if (empty($id) || empty($judul) || empty($penulis) || empty($tahun_terbit)) {
        http_response_code(400);
        echo json_encode(['message' => 'Semua field harus diisi']);
        exit;
    }

    // Query untuk mengupdate data di database berdasarkan ID
    $sql = "UPDATE buku SET judul = ?, penulis = ?, tahun_terbit = ? WHERE id = ?";
    $stmt = $koneksi->prepare($sql);

    // Bind dan execute
    $stmt->bind_param("ssii", $judul, $penulis, $tahun_terbit, $id);
    
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(['message' => 'Data berhasil diupdate']);
    } else {
        http_response_code(500);
        echo json_encode(['message' => 'Terjadi kesalahan saat mengupdate data']);
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
