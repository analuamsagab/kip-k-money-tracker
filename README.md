# KIP-K Money Tracker

Aplikasi pencatat keuangan pribadi untuk mahasiswa penerima KIP-K dengan fitur **Tahan Pengeluaranmu** untuk mengelola jatah jajan bulanan.

## Fitur

- **Dashboard** — Ringkasan saldo, pemasukan/pengeluaran, progress ring, diagram pie per kategori
- **Transaksi** — Catat pemasukan & pengeluaran, filter per bulan
- **Laporan** — Grafik tren keuangan bulanan
- **Tahan Pengeluaranmu** — Atur jatah jajan: buat alokasi kebutuhan, otomatis hitung sisa budget
- **Kategori** — Kelola kategori transaksi
- **Anggaran Semester** — Sistem semester → alokasi bulanan → kebutuhan bulanan
- **Backup Drive** — Backup & restore data ke Google Drive
- **Tema Gradien** — UI modern dengan gradien biru-ungu

## Unduh APK

Download rilis terbaru di **[GitHub Releases](https://github.com/analuamsagab/kip-k-money-tracker/releases)**.

## Prasyarat

- Flutter 3.x
- Dart 3.x
- Google Cloud Console — Drive API enabled (untuk backup)

## Build

```bash
flutter pub get
flutter build apk --release
```

## Tech Stack

- Flutter / Dart
- SQLite (drift)
- Provider (state management)
- Google Drive API (backup)
- fl_chart (grafik)
