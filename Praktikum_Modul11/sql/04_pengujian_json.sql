-- ============================================================
-- A. Identifikasi DBMS dan fasilitas dasar
-- ============================================================
SELECT VERSION();
SELECT @@version_comment;
SHOW ENGINES;
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';
SELECT JSON_VALID('{"nama":"Budi"}') AS json_valid,
       JSON_EXTRACT('{"nama":"Budi"}', '$.nama') AS nama;
SELECT @@transaction_isolation AS isolasi, @@autocommit AS autocommit;
SELECT NOW(), DATABASE();
 
-- ============================================================
-- B. Fungsi pembentuk dan pemeriksa JSON
-- ============================================================
SELECT JSON_OBJECT('id_laporan', 1, 'jenis', 'Lubang', 'berair', TRUE) AS objek_json;
SELECT JSON_ARRAY('A1', 'A2', 'B1') AS array_json;
SELECT JSON_VALID('{"diameter_cm":45}') AS valid_1,
       JSON_VALID('{"diameter_cm":45')  AS valid_2;
 
-- ============================================================
-- C. READ - membaca atribut JSON (SELECT)
-- ============================================================
-- atribut khusus tiap jenis kerusakan; atribut yang tidak ada bernilai NULL
SELECT id_deteksi, jenis_kerusakan,
       JSON_EXTRACT(detail_deteksi, '$.diameter_cm') AS diameter_cm,
       detail_deteksi->>'$.kedalaman_cm'             AS kedalaman_cm,
       detail_deteksi->>'$.panjang_m'                AS panjang_m,
       detail_deteksi->>'$.luas_m2'                  AS luas_m2
FROM hasil_deteksi
WHERE id_deteksi >= 101;
 
-- membaca atribut dari kolom JSON kotak_batas (sudah ada sejak Modul 10)
SELECT id_deteksi,
       kotak_batas->>'$.x'     AS x,
       kotak_batas->>'$.lebar' AS lebar,
       tingkat_keyakinan
FROM hasil_deteksi
WHERE id_deteksi >= 101;
 
-- gabungan relasional + JSON (JOIN laporan)
SELECT l.id_laporan, l.alamat, h.jenis_kerusakan, h.detail_deteksi->>'$.tingkat_pelapukan' AS pelapukan
FROM laporan l
JOIN hasil_deteksi h ON h.id_laporan = l.id_laporan
WHERE h.id_deteksi >= 101;
 
-- ============================================================
-- D. UPDATE - mengubah atribut JSON (JSON_SET)
-- ============================================================
-- kedalaman lubang pada deteksi 101 diperbarui dari 8 cm menjadi 10 cm
UPDATE hasil_deteksi
SET detail_deteksi = JSON_SET(detail_deteksi, '$.kedalaman_cm', 10)
WHERE id_deteksi = 101;
 
SELECT id_deteksi, detail_deteksi FROM hasil_deteksi WHERE id_deteksi = 101;
 
-- ============================================================
-- E. UPDATE - menambah atribut baru (JSON_SET dan JSON_ARRAY_APPEND)
-- ============================================================
-- atribut baru 'prioritas' pada deteksi 101
UPDATE hasil_deteksi
SET detail_deteksi = JSON_SET(detail_deteksi, '$.prioritas', 'tinggi')
WHERE id_deteksi = 101;
 
-- menambah elemen array petak_terdampak pada deteksi 103
UPDATE hasil_deteksi
SET detail_deteksi = JSON_ARRAY_APPEND(detail_deteksi, '$.petak_terdampak', 'B2')
WHERE id_deteksi = 103;
 
SELECT id_deteksi, detail_deteksi FROM hasil_deteksi WHERE id_deteksi IN (101, 103);
 
-- ============================================================
-- F. DELETE - menghapus atribut JSON (JSON_REMOVE)
-- ============================================================
UPDATE hasil_deteksi
SET detail_deteksi = JSON_REMOVE(detail_deteksi, '$.prioritas')
WHERE id_deteksi = 101;
 
SELECT id_deteksi, detail_deteksi FROM hasil_deteksi WHERE id_deteksi = 101;
 
-- ============================================================
-- G. Pencarian berdasarkan atribut JSON
-- ============================================================
-- (1) lubang dengan diameter >= 40 cm
SELECT id_deteksi, jenis_kerusakan, detail_deteksi
FROM hasil_deteksi
WHERE id_deteksi >= 101
  AND CAST(detail_deteksi->>'$.diameter_cm' AS UNSIGNED) >= 40;
 
-- (2) kerusakan yang melibatkan petak A1 (pencarian di dalam array)
SELECT id_deteksi, jenis_kerusakan
FROM hasil_deteksi
WHERE JSON_CONTAINS(detail_deteksi->'$.petak_terdampak', '"A1"');
 
-- (3) kerusakan jenis retak yang punya atribut panjang_m
SELECT id_deteksi, jenis_kerusakan, detail_deteksi->>'$.panjang_m' AS panjang_m
FROM hasil_deteksi
WHERE JSON_CONTAINS_PATH(detail_deteksi, 'one', '$.panjang_m');
 
-- (4) pelapukan 'sedang'
SELECT id_deteksi, jenis_kerusakan
FROM hasil_deteksi
WHERE detail_deteksi->>'$.tingkat_pelapukan' = 'sedang';
 
-- (5) jumlah atribut tiap deteksi
SELECT id_deteksi, jenis_kerusakan, JSON_LENGTH(detail_deteksi) AS jumlah_atribut
FROM hasil_deteksi
WHERE id_deteksi >= 101;
 
-- ============================================================
-- H. Indeks pada atribut JSON (generated column) dan EXPLAIN
-- ============================================================
-- JSON tidak dapat diindeks langsung; ekstrak atribut ke kolom turunan lalu indeks
ALTER TABLE hasil_deteksi
    ADD COLUMN diameter_cm INT
        GENERATED ALWAYS AS (CAST(JSON_UNQUOTE(JSON_EXTRACT(detail_deteksi, '$.diameter_cm')) AS UNSIGNED)) STORED,
    ADD INDEX idx_diameter (diameter_cm);
 
EXPLAIN SELECT id_deteksi FROM hasil_deteksi WHERE diameter_cm >= 40;
 
-- ============================================================
-- I. INSERT dan DELETE baris (uji siklus CRUD pada tabel dengan JSON)
-- ============================================================
INSERT INTO hasil_deteksi (id_deteksi, id_laporan, jenis_kerusakan, kotak_batas, tingkat_keyakinan, detail_deteksi)
VALUES (105, 4, 'Lubang (D40)', '{"x":10,"y":20,"lebar":50,"tinggi":40}', 66.00,
        '{"diameter_cm":20,"kedalaman_cm":3,"berair":false}');
 
SELECT COUNT(*) AS jumlah FROM hasil_deteksi WHERE id_deteksi >= 101;   -- 5
 
DELETE FROM hasil_deteksi WHERE id_deteksi = 105;
 
SELECT COUNT(*) AS jumlah FROM hasil_deteksi WHERE id_deteksi >= 101;   -- 4
 
-- ============================================================
-- J. Uji validasi JSON (HARUS GAGAL - letakkan paling akhir)
-- ============================================================
-- JSON tidak valid (kurung kurawal tidak ditutup) harus ditolak oleh tipe JSON
INSERT INTO hasil_deteksi (id_laporan, jenis_kerusakan, detail_deteksi)
VALUES (1, 'Uji JSON salah', '{"diameter_cm": 45');