# KIP-K Money Tracker

![Version](https://img.shields.io/badge/versi-2.5.0-indigo)

Aplikasi pencatat keuangan pribadi berbasis Flutter untuk mengelola uang beasiswa **KIP-Kuliah** dengan fitur unggulan **Tahan Pengeluaranmu** — sistem alokasi semester yang membagi total uang beasiswa menjadi jatah jajan bulanan agar keuangan terjaga sampai akhir semester.

> Aplikasi ini awalnya dirancang untuk kebutuhan pemilik repo (Bagas) dalam mengatur uang beasiswa KIP-Kuliah — mulai dari alokasi per semester, jatah jajan bulanan, hingga pelacakan pengeluaran per kategori. Namun aplikasi ini juga cocok digunakan oleh siapa saja yang ingin mengelola keuangan pribadi: cukup isi "modal" berkala (mis. gaji bulanan, uang saku, atau dana khusus) dan biarkan fitur Tahan membaginya otomatis.

## Fitur Utama

- **Dashboard** — Ringkasan saldo Cash & E-Wallet, pemasukan/pengeluaran sepanjang masa, dan diagram pie pengeluaran per kategori dengan filter **Semua Waktu / Bulan Ini / Pilih Bulan**
- **Transaksi** — Catat pemasukan & pengeluaran, pilih kategori dan metode pembayaran (Cash / E-Wallet), serta pindahkan uang antar dompet (transfer)
- **Tahan Pengeluaranmu** — Entri "Input Uang Semester": tentukan total uang semester dan durasinya, lalu sistem menghitung alokasi bulanan, jatah jajan, dan kebutuhan budget per kategori secara otomatis
- **Laporan** — Rekap keuangan dan tren per bulan
- **Kelola Kategori** — Tambah, edit, dan hapus kategori transaksi (kategori bawaan dilindungi agar tidak terhapus)
- **Backup & Restore Google Drive** — Backup database dengan login Google, lihat riwayat backup, restore, dan hapus file backup langsung dari pengaturan
- **Panduan & Bantuan** — Panduan penggunaan aplikasi langkah demi langkah di dalam aplikasi
- **UI Modern** — Material 3 dengan gradien Indigo

## Cara Penggunaan

Aplikasi memiliki 5 tab utama: **Dashboard, Transaksi, Laporan, Tahan, dan Setting**.

### 1. Mencatat Transaksi
- Buka tab **Transaksi**, tekan tombol **+**
- Isi nominal, pilih **kategori**, tipe (pemasukan/pengeluaran), dan **metode pembayaran** (Cash atau E-Wallet)
- Untuk memindahkan uang antar dompet, tekan ikon tukar di pojok atas tab Transaksi

### 2. Mengaktifkan Fitur Tahan (Inti Aplikasi)
- Buka tab **Tahan**, tekan **"Input Uang Semester"**
- Isi **total uang semester** (mis. total bantuan KIP-K yang diterima) dan **durasi** dalam bulan
- Sistem otomatis menghitung:
  - Alokasi uang per bulan
  - **Jatah jajan** bulanan (sisa setelah kebutuhan)
  - Kebutuhan budget per kategori yang bisa diatur di tab Kebutuhan
- Panel Jatah Jajan di Dashboard ikut memantau pemakaian bulanan

### 3. Backup & Restore
- Buka tab **Setting** → **Hubungkan Google** (login Google)
- Tekan **Backup Sekarang** untuk mengunggah database ke Google Drive
- Riwayat backup otomatis tampil — tekan ikon **restore** untuk memulihkan data, atau ikon **hapus** untuk menghapus file backup
- Saat belum login, riwayat menampilkan ajakan untuk login terlebih dahulu

### 4. Kelola Kategori
- Buka **Setting** → **Kelola Kategori**
- Tekan tombol **+** untuk menambah kategori (nama, tipe, ikon, warna)
- Ketuk kategori untuk mengedit; kategori bawaan tidak bisa dihapus, dan kategori yang masih dipakai transaksi dilindungi

## Unduh APK

Download rilis terbaru di **[GitHub Releases](https://github.com/analuamsagab/kip-k-money-tracker/releases)**.

## Prasyarat

- Flutter 3.x & Dart 3.x
- Android SDK (untuk build APK)
- Google Cloud Console dengan Drive API diaktifkan (untuk fitur backup)
  - `googleClientId` (web) dan `googleAndroidClientId` (Android OAuth) dikonfigurasi di `lib/config/app_config.dart`
  - SHA-1 sertifikat penanda tangan APK harus terdaftar pada OAuth client Android agar login Google berfungsi

## Build

```bash
flutter pub get
flutter build apk --release
```

## Tech Stack

- Flutter / Dart
- SQLite (drift)
- Riverpod (state management)
- Google Drive API (backup)
- fl_chart (grafik)