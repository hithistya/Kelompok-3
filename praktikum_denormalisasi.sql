-- TAHAP 1: Query JOIN + agregasi (on-the-fly)
SELECT
    p.id_pelanggan,
    p.nama_pelanggan,
    SUM(dp.jumlah * dp.harga_satuan) AS kalkulasi_total_belanja
FROM pelanggan p
JOIN pesanan ps ON p.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY p.id_pelanggan, p.nama_pelanggan;

-- TAHAP 2: Denormalisasi (tambah kolom turunan)
ALTER TABLE pelanggan
  ADD COLUMN total_belanja DECIMAL(15,2) NOT NULL DEFAULT 0;

UPDATE pelanggan p
JOIN (
  SELECT ps.id_pelanggan, SUM(dp.jumlah * dp.harga_satuan) AS total
  FROM pesanan ps
  JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
  GROUP BY ps.id_pelanggan
) h ON h.id_pelanggan = p.id_pelanggan
SET p.total_belanja = h.total;

-- TAHAP 3: Pembuktian (tanpa JOIN dan tanpa agregasi)
SELECT id_pelanggan, nama_pelanggan, total_belanja
FROM pelanggan;
