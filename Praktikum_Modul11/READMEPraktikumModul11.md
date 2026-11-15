## 2. Tentang Proyek

**Sistem Informasi Pelaporan dan Deteksi Kerusakan Jalan Berbasis AI.**

Alurnya: masyarakat melaporkan kerusakan jalan (foto, alamat, koordinat), model AI mendeteksi jenis kerusakan,
lalu Admin atau Petugas memverifikasi dan mengubah status laporan menjadi Menunggu, Diproses, atau Selesai.

**Perangkat yang digunakan**

| Komponen | Keterangan |
| --- | --- |
| DBMS | MySQL Community Server - GPL 8.0.30 |
| Storage engine | InnoDB |
| Pengelola database | phpMyAdmin 5.2.2 (localhost:3306) |
| Database | `db_kerusakan_jalan` (dibuat pada Modul 10) |
| Version control | Git dan GitHub |

**Lima tabel proyek:** `role`, `pengguna`, `laporan`, `hasil_deteksi`, `riwayat_status`.

## 3. Yang Dikerjakan pada Modul 11

1. **Identifikasi dan perbandingan DBMS:** MySQL, PostgreSQL, dan MongoDB.
2. **Implementasi JSON:** menambah kolom `detail_deteksi` bertipe JSON pada tabel `hasil_deteksi`, lalu menguji INSERT, SELECT, UPDATE, dan DELETE atribut JSON.
3. **Pemodelan objek:** diagram class (class, attribute, method, inheritance) dan pemetaannya ke tabel relasional.
4. **Analisis lingkup penerapan:** kebutuhan organisasi, model data, fitur DBMS, dan alasan pemilihan teknologi.

**Mengapa JSON?** Setiap jenis kerusakan punya atribut yang berbeda. Dengan kolom JSON, atribut itu disimpan dalam satu kolom
tanpa banyak kolom kosong.

| Jenis kerusakan | Atribut di `detail_deteksi` |
| --- | --- |
| Lubang | `diameter_cm`, `kedalaman_cm`, `berair` |
| Retak memanjang | `panjang_m`, `lebar_retak_mm`, `arah` |
| Retak melintang | `panjang_m`, `lebar_retak_mm` |
| Retak kulit buaya | `luas_m2`, `tingkat_pelapukan`, `petak_terdampak` (array) |

Kolom `kotak_batas` sudah bertipe JSON sejak Modul 10.

## 4. Isi Repository

```
praktikum_modul11/
|-- sql/
|   |-- 01_database.sql        memakai database db_kerusakan_jalan
|   |-- 02_tabel.sql           menambah kolom JSON detail_deteksi (ALTER TABLE)
|   |-- 03_data_awal.sql       mengisi data uji (id_deteksi 101-104)
|   `-- 04_pengujian_json.sql  pengujian JSON (bagian A sampai J)
|-- dokumentasi/
|   |-- perbandingan_dbms.pdf  identifikasi dan perbandingan 3 DBMS
|   |-- analisis_objek.pdf     pemodelan objek dan analisis model data
|   |-- lingkup_penerapan.pdf  analisis lingkup penerapan basis data
|   `-- worksheet_modul11.pdf  laporan lembar kerja
|-- diagram/
|   `-- pemodelan_objek.png    diagram class
|-- modul11.sql                gabungan 01 sampai 04 (jalankan sekali jalan)
`-- README.md
```

**Isi `04_pengujian_json.sql`**

| Bagian | Pengujian |
| --- | --- |
| A | Identifikasi DBMS: versi, engine, charset, dukungan JSON |
| B | Fungsi `JSON_OBJECT`, `JSON_ARRAY`, `JSON_VALID` |
| C | **SELECT**: membaca atribut JSON (`->>`, `JSON_EXTRACT`) dan JOIN dengan `laporan` |
| D | **UPDATE**: mengubah atribut (`JSON_SET`) |
| E | **UPDATE**: menambah atribut baru dan elemen array (`JSON_SET`, `JSON_ARRAY_APPEND`) |
| F | **DELETE**: menghapus atribut (`JSON_REMOVE`) |
| G | Pencarian berdasarkan atribut JSON (`JSON_CONTAINS`, `JSON_CONTAINS_PATH`, `JSON_LENGTH`) |
| H | Indeks pada atribut JSON (generated column) dan `EXPLAIN` |
| I | **INSERT** dan **DELETE** baris uji (id 105) |
| J | Uji validasi: JSON tidak valid harus ditolak (**error #3140 memang diharapkan**) |

## 5. Cara Menjalankan

**Persiapan**
1. Jalankan MySQL 8.0 dan buka phpMyAdmin.
2. **Backup** dahulu: pilih database `db_kerusakan_jalan`, tab **Export**, lalu simpan file SQL-nya. Script ini mengubah tabel asli.
3. Pastikan tabel `laporan` masih memiliki `id_laporan` 1 sampai 4, karena data uji merujuk ke sana.

**Menjalankan (pilih salah satu)**
- **Cara cepat:** buka tab **SQL**, tempel isi `modul11.sql`, lalu **Go**.
- **Cara bertahap:** jalankan `01` lalu `02`, `03`, dan `04` secara berurutan.

**Aturan penting**
- `02_tabel.sql` dijalankan **satu kali saja**. Mengulangnya menimbulkan error kolom sudah ada.
- Urutannya harus `02` dulu baru `03`, karena `03` memakai kolom `detail_deteksi`.
- Data uji memakai `id_deteksi` 101 sampai 105 agar tidak bentrok dengan data Modul 10.

**Cek hasil**

```sql
SELECT id_deteksi, jenis_kerusakan, detail_deteksi
FROM hasil_deteksi
WHERE id_deteksi >= 101;
```

Hasil yang benar: 4 baris (id 101 sampai 104) dengan isi JSON yang berbeda tiap jenis kerusakan.

## 6. Bukti Tangkapan Layar
<img width="1241" height="210" alt="WhatsApp Image 2026-11-13 at 13 01 22" src="https://github.com/user-attachments/assets/3dead47e-2c7b-4f41-8294-87095035bb7f" />
<img width="1300" height="635" alt="WhatsApp Image 2026-11-13 at 13 16 02" src="https://github.com/user-attachments/assets/379ebd52-5a71-4262-a71d-f52628d8aa35" />
<img width="1299" height="351" alt="WhatsApp Image 2026-11-13 at 13 17 44" src="https://github.com/user-attachments/assets/c525e282-c34d-4db9-b68f-6d6800f5e565" />
<img width="1146" height="422" alt="WhatsApp Image 2026-11-13 at 13 19 03" src="https://github.com/user-attachments/assets/7c9c4a0b-d1c6-4cdb-b934-14e81302c77e" />
<img width="830" height="326" alt="WhatsApp Image 2026-11-13 at 13 19 41" src="https://github.com/user-attachments/assets/eeb1aa15-44d8-4312-a247-402c3f8a9fc8" />
