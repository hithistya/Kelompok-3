-- =====================================================================
-- MEMBUAT DATABASE
-- =====================================================================
CREATE DATABASE db_laporan_kerusakan_jalan;
USE db_laporan_kerusakan_jalan;

CREATE TABLE role (
    id_role INT AUTO_INCREMENT PRIMARY KEY,
    nama_role VARCHAR(50) NOT NULL UNIQUE,
    deskripsi TEXT
);

CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    id_role INT NOT NULL,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    kata_sandi VARCHAR(255) NOT NULL,

    FOREIGN KEY (id_role)
        REFERENCES role(id_role)
);

CREATE TABLE laporan (
    id_laporan INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna INT NOT NULL,
    tingkat_keparahan VARCHAR(50),
    foto VARCHAR(255),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    alamat TEXT,
    keterangan TEXT,
    waktu_lapor DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),

    FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
);

CREATE TABLE hasil_deteksi (
    id_deteksi INT AUTO_INCREMENT PRIMARY KEY,
    id_laporan INT NOT NULL,
    jenis_kerusakan VARCHAR(100),
    kotak_batas JSON,
    tingkat_keyakinan DECIMAL(5,2),

    FOREIGN KEY (id_laporan)
        REFERENCES laporan(id_laporan)
);

CREATE TABLE riwayat_status (
    id_riwayat INT AUTO_INCREMENT PRIMARY KEY,
    id_laporan INT NOT NULL,
    id_pengguna INT NOT NULL,
    waktu_perubahan DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_baru VARCHAR(50),
    catatan TEXT,

    FOREIGN KEY (id_laporan)
        REFERENCES laporan(id_laporan),

    FOREIGN KEY (id_pengguna)
        REFERENCES pengguna(id_pengguna)
);



-- =====================================================================
-- TAHAP 1 : EKSPLORASI DBMS DAN ARSITEKTUR
-- =====================================================================

SELECT VERSION()          AS versi_dbms;
SELECT @@version_comment  AS vendor;
SELECT @@hostname AS host, @@port AS port, @@datadir AS lokasi_data;
SELECT @@default_storage_engine AS engine_default;

SHOW ENGINES;
SHOW DATABASES;
SHOW TABLE STATUS;

-- Storage engine dan perkiraan jumlah baris tiap tabel
SELECT TABLE_NAME, ENGINE, TABLE_ROWS, TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_kerusakan_jalan';

SHOW CREATE TABLE laporan;


-- =====================================================================
-- TAHAP 2 : IMPLEMENTASI SKEMA DAN INTEGRITAS
-- (Skema sudah dibuat oleh db_kerusakan_jalan.sql. Bagian ini
--  memeriksa struktur, relasi, dan constraint-nya.)
-- =====================================================================

SHOW TABLES;
SHOW CREATE TABLE role;
SHOW CREATE TABLE pengguna;
SHOW CREATE TABLE hasil_deteksi;
SHOW CREATE TABLE riwayat_status;

-- Daftar foreign key (relasi one-to-many antartabel)
SELECT TABLE_NAME        AS tabel_anak,
       COLUMN_NAME       AS kolom_fk,
       CONSTRAINT_NAME   AS nama_constraint,
       REFERENCED_TABLE_NAME  AS tabel_induk,
       REFERENCED_COLUMN_NAME AS kolom_induk
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'db_kerusakan_jalan'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- Aturan update/delete pada setiap foreign key
SELECT CONSTRAINT_NAME, TABLE_NAME, REFERENCED_TABLE_NAME,
       UPDATE_RULE, DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'db_kerusakan_jalan';


-- =====================================================================
-- TAHAP 3 : OPERASI CRUD
-- =====================================================================

-- ---- CREATE ---------------------------------------------------------
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


-- ---- READ -----------------------------------------------------------
SELECT id_laporan, tingkat_keparahan, alamat, status
FROM laporan;

SELECT *
FROM laporan
WHERE tingkat_keparahan = 'Tinggi';

-- Read dengan JOIN: laporan beserta pelapor dan hasil deteksinya
SELECT l.id_laporan, p.nama AS pelapor, l.alamat,
       d.jenis_kerusakan, d.tingkat_keyakinan, l.status
FROM laporan l
JOIN pengguna p       ON p.id_pengguna = l.id_pengguna
JOIN hasil_deteksi d  ON d.id_laporan  = l.id_laporan
ORDER BY l.id_laporan;

-- Membaca isi kolom JSON (kotak_batas)
SELECT id_deteksi,
       JSON_EXTRACT(kotak_batas, '$.x')      AS x,
       JSON_EXTRACT(kotak_batas, '$.y')      AS y,
       JSON_EXTRACT(kotak_batas, '$.width')  AS lebar,
       JSON_EXTRACT(kotak_batas, '$.height') AS tinggi
FROM hasil_deteksi;

-- ---- UPDATE ---------------------------------------------------------
UPDATE laporan
SET status = 'Diproses'
WHERE id_laporan = 2;

SELECT id_laporan, status FROM laporan WHERE id_laporan = 2;

-- ---- DELETE ---------------------------------------------------------
-- Hanya pengguna yang belum punya laporan/riwayat yang bisa dihapus
DELETE FROM pengguna
WHERE email = 'dewi@gmail.com';

SELECT * FROM pengguna;


-- =====================================================================
-- TAHAP 4 : TRANSAKSI (COMMIT dan ROLLBACK)
-- =====================================================================

-- ---- Uji COMMIT: satu laporan lengkap (laporan + deteksi + riwayat) --
START TRANSACTION;

INSERT INTO laporan
  (id_laporan, id_pengguna, tingkat_keparahan, foto, latitude, longitude,
   alamat, keterangan, waktu_lapor, status)
VALUES
  (5, 1, 'Tinggi', 'jalan_rusak5.jpg', -7.4900000, 112.4600000,
   'Jl. Empunala', 'Lubang jalan di dekat perempatan',
   '2026-11-05 07:45:00', 'Menunggu');

INSERT INTO hasil_deteksi
  (id_deteksi, id_laporan, jenis_kerusakan, kotak_batas, tingkat_keyakinan)
VALUES
  (5, 5, 'Lubang Jalan',
   JSON_OBJECT('x', 140, 'y', 90, 'width', 210, 'height', 160), 93.40);

INSERT INTO riwayat_status
  (id_riwayat, id_laporan, id_pengguna, waktu_perubahan, status_baru, catatan)
VALUES
  (6, 5, 2, '2026-11-05 08:00:00', 'Menunggu',
   'Laporan menunggu pemeriksaan petugas');

COMMIT;

SELECT * FROM laporan         WHERE id_laporan = 5;
SELECT * FROM hasil_deteksi   WHERE id_laporan = 5;
SELECT * FROM riwayat_status  WHERE id_laporan = 5;


-- ---- Uji ROLLBACK ---------------------------------------------------
START TRANSACTION;

INSERT INTO laporan
  (id_laporan, id_pengguna, tingkat_keparahan, foto, latitude, longitude,
   alamat, keterangan, waktu_lapor, status)
VALUES
  (6, 3, 'Sedang', 'jalan_rusak6.jpg', -7.4950000, 112.4650000,
   'Jl. Uji Rollback', 'Data ini akan dibatalkan',
   '2026-11-06 10:00:00', 'Menunggu');

INSERT INTO hasil_deteksi
  (id_deteksi, id_laporan, jenis_kerusakan, kotak_batas, tingkat_keyakinan)
VALUES
  (6, 6, 'Retakan Jalan',
   JSON_OBJECT('x', 60, 'y', 70, 'width', 150, 'height', 80), 88.10);

INSERT INTO riwayat_status
  (id_riwayat, id_laporan, id_pengguna, waktu_perubahan, status_baru, catatan)
VALUES
  (7, 6, 2, '2026-11-06 10:05:00', 'Menunggu', 'Data uji rollback');

ROLLBACK;

SELECT * FROM laporan         WHERE id_laporan = 6;
SELECT * FROM hasil_deteksi   WHERE id_laporan = 6;
SELECT * FROM riwayat_status  WHERE id_laporan = 6;

SET SESSION cte_max_recursion_depth = 1000000;

INSERT INTO laporan
  (id_pengguna, tingkat_keparahan, foto, latitude, longitude,
   alamat, keterangan, waktu_lapor, status)
WITH RECURSIVE seq (n) AS (
  SELECT 1
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 1000000
)
SELECT
  1 + (n % 3),                                             
  ELT(1 + (n % 3), 'Rendah', 'Sedang', 'Tinggi'),
  CONCAT('sim_', n, '.jpg'),
  -7.4000000 - (n % 1000) * 0.0001,
  112.4000000 + (n % 1000) * 0.0001,
  CONCAT('Jl. Simulasi No. ', n),
  'Data simulasi performa',
  DATE_ADD('2025-01-01 00:00:00', INTERVAL ((n * 7) % 960000) MINUTE),
  ELT(1 + (n % 3), 'Menunggu', 'Diproses', 'Selesai')
FROM seq;

-- ---- 5.2 Hasil deteksi untuk setiap laporan simulasi ----------------
INSERT INTO hasil_deteksi
  (id_laporan, jenis_kerusakan, kotak_batas, tingkat_keyakinan)
SELECT
  id_laporan,
  IF(id_laporan % 2 = 0, 'Lubang Jalan', 'Retakan Jalan'),
  JSON_OBJECT('x', id_laporan % 400,
              'y', id_laporan % 300,
              'width',  50 + id_laporan % 200,
              'height', 40 + id_laporan % 150),
  50 + (id_laporan % 4900) / 100
FROM laporan
WHERE keterangan = 'Data simulasi performa';

-- ---- 5.3 Verifikasi dan perbarui statistik tabel --------------------
SELECT COUNT(*) AS jumlah_laporan        FROM laporan;
SELECT COUNT(*) AS jumlah_hasil_deteksi  FROM hasil_deteksi;
ANALYZE TABLE laporan, hasil_deteksi;

-- ---- 5.4 QUERY 1: pencarian berdasarkan rentang tanggal -------------
-- SEBELUM index (laporan hanya punya index pada id_pengguna)
EXPLAIN
SELECT id_laporan, id_pengguna, tingkat_keparahan, status, waktu_lapor
FROM laporan
WHERE waktu_lapor >= '2026-10-01'
  AND waktu_lapor <  '2026-11-01';

-- Waktu eksekusi nyata (MySQL 8.0.18 ke atas)
EXPLAIN ANALYZE
SELECT id_laporan, id_pengguna, tingkat_keparahan, status, waktu_lapor
FROM laporan
WHERE waktu_lapor >= '2026-10-01'
  AND waktu_lapor <  '2026-11-01';

-- Membuat index
CREATE INDEX idx_laporan_waktu ON laporan (waktu_lapor);
SHOW INDEX FROM laporan;

-- SESUDAH index: jalankan ulang kedua perintah di atas
EXPLAIN
SELECT id_laporan, id_pengguna, tingkat_keparahan, status, waktu_lapor
FROM laporan
WHERE waktu_lapor >= '2026-10-01'
  AND waktu_lapor <  '2026-11-01';

EXPLAIN ANALYZE
SELECT id_laporan, id_pengguna, tingkat_keparahan, status, waktu_lapor
FROM laporan
WHERE waktu_lapor >= '2026-10-01'
  AND waktu_lapor <  '2026-11-01';

-- ---- 5.5 Contoh query yang MENGGAGALKAN penggunaan index ------------
EXPLAIN
SELECT id_laporan FROM laporan
WHERE DATE(waktu_lapor) = '2026-10-15';

-- Versi yang ramah index
EXPLAIN
SELECT id_laporan FROM laporan
WHERE waktu_lapor >= '2026-10-15' AND waktu_lapor < '2026-10-16';

-- ---- 5.6 QUERY 2: filter beberapa kolom -> composite index ----------
-- SEBELUM
EXPLAIN
SELECT id_laporan, alamat, waktu_lapor
FROM laporan
WHERE status = 'Menunggu'
  AND tingkat_keparahan = 'Tinggi'
  AND waktu_lapor >= '2026-10-01';

CREATE INDEX idx_laporan_status_parah_waktu
ON laporan (status, tingkat_keparahan, waktu_lapor);

-- SESUDAH (jalankan ulang EXPLAIN di atas)
EXPLAIN
SELECT id_laporan, alamat, waktu_lapor
FROM laporan
WHERE status = 'Menunggu'
  AND tingkat_keparahan = 'Tinggi'
  AND waktu_lapor >= '2026-10-01';

-- ---- 5.7 QUERY 3: JOIN tiga tabel ----------------------------------
-- SEBELUM index pada hasil_deteksi(jenis_kerusakan, tingkat_keyakinan)
EXPLAIN
SELECT l.id_laporan, p.nama, l.alamat,
       d.jenis_kerusakan, d.tingkat_keyakinan
FROM laporan l
JOIN pengguna p      ON p.id_pengguna = l.id_pengguna
JOIN hasil_deteksi d ON d.id_laporan  = l.id_laporan
WHERE d.jenis_kerusakan = 'Lubang Jalan'
  AND d.tingkat_keyakinan >= 95
  AND l.waktu_lapor >= '2026-10-01'
  AND l.waktu_lapor <  '2026-11-01';

CREATE INDEX idx_deteksi_jenis_keyakinan
ON hasil_deteksi (jenis_kerusakan, tingkat_keyakinan);

-- SESUDAH (jalankan ulang EXPLAIN di atas)
EXPLAIN
SELECT l.id_laporan, p.nama, l.alamat,
       d.jenis_kerusakan, d.tingkat_keyakinan
FROM laporan l
JOIN pengguna p      ON p.id_pengguna = l.id_pengguna
JOIN hasil_deteksi d ON d.id_laporan  = l.id_laporan
WHERE d.jenis_kerusakan = 'Lubang Jalan'
  AND d.tingkat_keyakinan >= 95
  AND l.waktu_lapor >= '2026-10-01'
  AND l.waktu_lapor <  '2026-11-01';

-- ---- 5.8 QUERY 4: agregasi -----------------------------------------
EXPLAIN
SELECT status, COUNT(*) AS jumlah
FROM laporan
GROUP BY status;

-- ---- 5.9 Biaya index: ukuran data vs ukuran index -------------------
SELECT TABLE_NAME,
       ROUND(DATA_LENGTH  / 1024 / 1024, 1) AS data_mb,
       ROUND(INDEX_LENGTH / 1024 / 1024, 1) AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'db_kerusakan_jalan'
ORDER BY DATA_LENGTH DESC;


-- =====================================================================
-- TAHAP 6 : PEMELIHARAAN (BACKUP, RESTORE, DAN PEMBERSIHAN)
-- =====================================================================
DELETE d
FROM hasil_deteksi d
JOIN laporan l ON l.id_laporan = d.id_laporan
WHERE l.keterangan = 'Data simulasi performa';

DELETE FROM laporan
WHERE keterangan = 'Data simulasi performa';

-- Mengembalikan penghitung AUTO_INCREMENT ke nilai wajar
ALTER TABLE laporan        AUTO_INCREMENT = 7;
ALTER TABLE hasil_deteksi  AUTO_INCREMENT = 7;
ALTER TABLE riwayat_status AUTO_INCREMENT = 8;
ALTER TABLE pengguna       AUTO_INCREMENT = 4;

SELECT 'laporan' AS tabel, COUNT(*) AS jumlah FROM laporan
UNION ALL SELECT 'hasil_deteksi', COUNT(*) FROM hasil_deteksi
UNION ALL SELECT 'pengguna',      COUNT(*) FROM pengguna
UNION ALL SELECT 'riwayat_status',COUNT(*) FROM riwayat_status
UNION ALL SELECT 'role',          COUNT(*) FROM role;

-- Memverifikasi: jumlah baris harus sama dengan database asli
SELECT 'laporan' AS tabel,
       (SELECT COUNT(*) FROM db_kerusakan_jalan.laporan)         AS asli,
       (SELECT COUNT(*) FROM db_kerusakan_jalan_restore.laporan) AS hasil_restore
UNION ALL
SELECT 'hasil_deteksi',
       (SELECT COUNT(*) FROM db_kerusakan_jalan.hasil_deteksi),
       (SELECT COUNT(*) FROM db_kerusakan_jalan_restore.hasil_deteksi)
UNION ALL
SELECT 'pengguna',
       (SELECT COUNT(*) FROM db_kerusakan_jalan.pengguna),
       (SELECT COUNT(*) FROM db_kerusakan_jalan_restore.pengguna)
UNION ALL
SELECT 'riwayat_status',
       (SELECT COUNT(*) FROM db_kerusakan_jalan.riwayat_status),
       (SELECT COUNT(*) FROM db_kerusakan_jalan_restore.riwayat_status)
UNION ALL
SELECT 'role',
       (SELECT COUNT(*) FROM db_kerusakan_jalan.role),
       (SELECT COUNT(*) FROM db_kerusakan_jalan_restore.role);

-- Memastikan index dan foreign key ikut pulih
SHOW INDEX FROM db_kerusakan_jalan_restore.laporan;

