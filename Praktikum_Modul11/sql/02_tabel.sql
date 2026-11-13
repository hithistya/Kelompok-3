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

ALTER TABLE hasil_deteksi
    ADD COLUMN detail_deteksi JSON NULL AFTER tingkat_keyakinan;