INSERT INTO role (nama_role, deskripsi)
VALUES
('Masyarakat', 'Pengguna yang dapat membuat laporan kerusakan'),
('Petugas', 'Pengguna yang bertugas memeriksa dan menangani laporan'),
('Admin', 'Pengguna yang mengelola sistem');

INSERT INTO pengguna
(id_role, nama, email, kata_sandi)
VALUES
(1, 'Andi Saputra', 'andi@gmail.com', 'andi123'),
(2, 'Budi Santoso', 'budi@gmail.com', 'budi123'),
(3, 'Citra Amelia', 'citra@gmail.com', 'citra123');

INSERT INTO laporan
(id_pengguna, tingkat_keparahan, foto, latitude, longitude,
alamat, keterangan, waktu_lapor, status)
VALUES
(1, 'Tinggi', 'jalan_rusak1.jpg', -7.4700, 112.4400,
'Jl. Raya Mojokerto', 'Terdapat lubang besar pada jalan',
'2026-11-01 08:30:00', 'Diproses'),

(1, 'Sedang', 'jalan_rusak2.jpg', -7.4750, 112.4450,
'Jl. Gajah Mada', 'Permukaan jalan mengalami retakan',
'2026-11-02 10:15:00', 'Menunggu'),

(2, 'Tinggi', 'jalan_rusak3.jpg', -7.4800, 112.4500,
'Jl. Majapahit', 'Kerusakan jalan cukup parah',
'2026-11-03 13:20:00', 'Selesai'),

(3, 'Rendah', 'jalan_rusak4.jpg', -7.4850, 112.4550,
'Jl. Pahlawan', 'Terdapat retakan kecil pada jalan',
'2026-11-04 09:00:00', 'Diproses');

INSERT INTO hasil_deteksi
(id_laporan, jenis_kerusakan, kotak_batas, tingkat_keyakinan)
VALUES
(1, 'Lubang Jalan',
'{"x":120,"y":80,"width":200,"height":150}', 95.50),

(2, 'Retakan Jalan',
'{"x":50,"y":60,"width":180,"height":90}', 89.75),

(3, 'Lubang Jalan',
'{"x":100,"y":100,"width":250,"height":180}', 97.20),

(4, 'Retakan Jalan',
'{"x":70,"y":40,"width":120,"height":60}', 85.30);

INSERT INTO riwayat_status
(id_laporan, id_pengguna, waktu_perubahan, status_baru, catatan)
VALUES
(1, 2, '2026-11-01 09:00:00', 'Diproses',
'Laporan diterima dan sedang diperiksa'),

(1, 3, '2026-11-01 10:00:00', 'Diproses',
'Admin telah memverifikasi laporan'),

(2, 2, '2026-11-02 10:30:00', 'Menunggu',
'Laporan menunggu pemeriksaan petugas'),

(3, 2, '2026-11-03 14:00:00', 'Selesai',
'Perbaikan jalan telah diselesaikan'),

(4, 3, '2026-11-04 09:30:00', 'Diproses',
'Laporan diteruskan kepada petugas');