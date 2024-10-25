<?php
include("./config.php");

// Cek apakah request method adalah POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Ambil ID buku dari request
    $id = $_POST['id'] ?? '';

    // Validasi input
    if (empty($id)) {
        http_response_code(400);
        echo json_encode(['message' => 'ID buku harus diisi']);
        exit;
    }

    // Query untuk menghapus data dari database berdasarkan ID
    $sql = "DELETE FROM buku WHERE id = ?";
    $stmt = $koneksi->prepare($sql);

    // Bind dan execute
    $stmt->bind_param("i", $id);
    
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(['message' => 'Data berhasil dihapus']);
    } else {
        http_response_code(500);
        echo json_encode(['message' => 'Terjadi kesalahan saat menghapus data']);
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
