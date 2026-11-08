-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 08, 2026 at 12:27 PM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kerusakan_jalan`
--

-- --------------------------------------------------------

--
-- Table structure for table `hasil_deteksi`
--

CREATE TABLE `hasil_deteksi` (
  `id_deteksi` int NOT NULL,
  `id_laporan` int NOT NULL,
  `jenis_kerusakan` varchar(100) DEFAULT NULL,
  `kotak_batas` json DEFAULT NULL,
  `tingkat_keyakinan` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `hasil_deteksi`
--

INSERT INTO `hasil_deteksi` (`id_deteksi`, `id_laporan`, `jenis_kerusakan`, `kotak_batas`, `tingkat_keyakinan`) VALUES
(1, 1, 'Lubang Jalan', '{\"x\": 120, \"y\": 80, \"width\": 200, \"height\": 150}', '95.50'),
(2, 2, 'Retakan Jalan', '{\"x\": 50, \"y\": 60, \"width\": 180, \"height\": 90}', '89.75'),
(3, 3, 'Lubang Jalan', '{\"x\": 100, \"y\": 100, \"width\": 250, \"height\": 180}', '97.20'),
(4, 4, 'Retakan Jalan', '{\"x\": 70, \"y\": 40, \"width\": 120, \"height\": 60}', '85.30'),
(5, 5, 'Lubang Jalan', '{\"x\": 140, \"y\": 90, \"width\": 210, \"height\": 160}', '93.40');

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id_laporan` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `tingkat_keparahan` varchar(50) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `alamat` text,
  `keterangan` text,
  `waktu_lapor` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `laporan`
--

INSERT INTO `laporan` (`id_laporan`, `id_pengguna`, `tingkat_keparahan`, `foto`, `latitude`, `longitude`, `alamat`, `keterangan`, `waktu_lapor`, `status`) VALUES
(1, 1, 'Tinggi', 'jalan_rusak1.jpg', '-7.4700000', '112.4400000', 'Jl. Raya Mojokerto', 'Terdapat lubang besar pada jalan', '2026-11-01 08:30:00', 'Diproses'),
(2, 1, 'Sedang', 'jalan_rusak2.jpg', '-7.4750000', '112.4450000', 'Jl. Gajah Mada', 'Permukaan jalan mengalami retakan', '2026-11-02 10:15:00', 'Diproses'),
(3, 2, 'Tinggi', 'jalan_rusak3.jpg', '-7.4800000', '112.4500000', 'Jl. Majapahit', 'Kerusakan jalan cukup parah', '2026-11-03 13:20:00', 'Selesai'),
(4, 3, 'Rendah', 'jalan_rusak4.jpg', '-7.4850000', '112.4550000', 'Jl. Pahlawan', 'Terdapat retakan kecil pada jalan', '2026-11-04 09:00:00', 'Diproses'),
(5, 1, 'Tinggi', 'jalan_rusak5.jpg', '-7.4900000', '112.4600000', 'Jl. Empunala', 'Lubang jalan di dekat perempatan', '2026-11-05 07:45:00', 'Menunggu');

-- --------------------------------------------------------

--
-- Table structure for table `pengguna`
--

CREATE TABLE `pengguna` (
  `id_pengguna` int NOT NULL,
  `id_role` int NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `pengguna`
--

INSERT INTO `pengguna` (`id_pengguna`, `id_role`, `nama`, `email`, `password`) VALUES
(1, 3, 'Andi Saputra', 'andi@gmail.com', 'andi123'),
(2, 2, 'Budi Santoso', 'budi@gmail.com', 'budi123'),
(3, 3, 'Citra Amelia', 'citra@gmail.com', 'citra123');

-- --------------------------------------------------------

--
-- Table structure for table `riwayat_status`
--

CREATE TABLE `riwayat_status` (
  `id_riwayat` int NOT NULL,
  `id_laporan` int NOT NULL,
  `id_pengguna` int NOT NULL,
  `waktu_perubahan` datetime DEFAULT CURRENT_TIMESTAMP,
  `status_baru` varchar(50) DEFAULT NULL,
  `catatan` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `riwayat_status`
--

INSERT INTO `riwayat_status` (`id_riwayat`, `id_laporan`, `id_pengguna`, `waktu_perubahan`, `status_baru`, `catatan`) VALUES
(1, 1, 2, '2026-11-01 09:00:00', 'Diproses', 'Laporan diterima dan sedang diperiksa'),
(2, 1, 3, '2026-11-01 10:00:00', 'Diproses', 'Admin telah memverifikasi laporan'),
(3, 2, 2, '2026-11-02 10:30:00', 'Menunggu', 'Laporan menunggu pemeriksaan petugas'),
(4, 3, 2, '2026-11-03 14:00:00', 'Selesai', 'Perbaikan jalan telah diselesaikan'),
(5, 4, 3, '2026-11-04 09:30:00', 'Diproses', 'Laporan diteruskan kepada petugas'),
(6, 5, 2, '2026-11-05 08:00:00', 'Menunggu', 'Laporan menunggu pemeriksaan petugas');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `id_role` int NOT NULL,
  `nama_role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`id_role`, `nama_role`) VALUES
(3, 'Admin'),
(2, 'Petugas');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  ADD PRIMARY KEY (`id_deteksi`),
  ADD KEY `id_laporan` (`id_laporan`),
  ADD KEY `idx_deteksi_jenis_keyakinan` (`jenis_kerusakan`,`tingkat_keyakinan`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id_laporan`),
  ADD KEY `id_pengguna` (`id_pengguna`),
  ADD KEY `idx_laporan_waktu` (`waktu_lapor`),
  ADD KEY `idx_laporan_status_parah_waktu` (`status`,`tingkat_keparahan`,`waktu_lapor`);

--
-- Indexes for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD PRIMARY KEY (`id_pengguna`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `id_role` (`id_role`);

--
-- Indexes for table `riwayat_status`
--
ALTER TABLE `riwayat_status`
  ADD PRIMARY KEY (`id_riwayat`),
  ADD KEY `id_laporan` (`id_laporan`),
  ADD KEY `id_pengguna` (`id_pengguna`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id_role`),
  ADD UNIQUE KEY `nama_role` (`nama_role`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  MODIFY `id_deteksi` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1048567;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id_laporan` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1048567;

--
-- AUTO_INCREMENT for table `pengguna`
--
ALTER TABLE `pengguna`
  MODIFY `id_pengguna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `riwayat_status`
--
ALTER TABLE `riwayat_status`
  MODIFY `id_riwayat` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `id_role` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hasil_deteksi`
--
ALTER TABLE `hasil_deteksi`
  ADD CONSTRAINT `hasil_deteksi_ibfk_1` FOREIGN KEY (`id_laporan`) REFERENCES `laporan` (`id_laporan`);

--
-- Constraints for table `laporan`
--
ALTER TABLE `laporan`
  ADD CONSTRAINT `laporan_ibfk_1` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);

--
-- Constraints for table `pengguna`
--
ALTER TABLE `pengguna`
  ADD CONSTRAINT `pengguna_ibfk_1` FOREIGN KEY (`id_role`) REFERENCES `role` (`id_role`);

--
-- Constraints for table `riwayat_status`
--
ALTER TABLE `riwayat_status`
  ADD CONSTRAINT `riwayat_status_ibfk_1` FOREIGN KEY (`id_laporan`) REFERENCES `laporan` (`id_laporan`),
  ADD CONSTRAINT `riwayat_status_ibfk_2` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna` (`id_pengguna`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
