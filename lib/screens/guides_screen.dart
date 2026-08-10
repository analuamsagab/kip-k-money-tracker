import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../widgets/gradient_app_bar.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradientAppBar(title: 'Panduan & Bantuan'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _guideCard(
            icon: Icons.edit_note,
            color: Colors.blue[700]!,
            title: 'Catat Transaksi',
            steps: [
              'Buka tab Transaksi, lalu tekan tombol + untuk menambah pemasukan atau pengeluaran.',
              'Pilih kategori, isi nominal, dan pilih metode pembayaran (Cash atau E-Wallet).',
              'Untuk memindahkan uang antar dompet, tekan ikon tukar di pojok tab Transaksi.',
            ],
          ),
          const SizedBox(height: 16),
          _guideCard(
            icon: Icons.shield,
            color: const Color(AppConfig.primaryColor),
            title: 'Fitur Tahan',
            steps: [
              'Buka tab Tahan, lalu tekan "Input Uang Semester".',
              'Isi total uang semester (mis. total KIP-K) dan durasinya.',
              'Jatah jajan bulanan dihitung otomatis, dan kamu bisa mengatur kebutuhan budget per kategori.',
            ],
          ),
          const SizedBox(height: 16),
          _guideCard(
            icon: Icons.cloud_done_outlined,
            color: Colors.green[700]!,
            title: 'Backup & Restore',
            steps: [
              'Di tab Setting, hubungkan akun Google untuk mengaktifkan backup.',
              'Tekan "Backup Sekarang" untuk mengunggah database ke Google Drive.',
              'Riwayat backup tampil di bawahnya — tekan ikon restore untuk memulihkan, atau ikon hapus untuk menghapus file backup.',
            ],
          ),
          const SizedBox(height: 16),
          _guideCard(
            icon: Icons.category_outlined,
            color: Colors.orange[800]!,
            title: 'Kelola Kategori',
            steps: [
              'Masuk ke Setting > Kelola Kategori untuk menambah, mengedit, atau menghapus kategori.',
              'Kategori baru langsung muncul di semua pilihan transaksi.',
              'Kategori bawaan tidak bisa dihapus, dan kategori yang masih dipakai transaksi juga dilindungi.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _guideCard({
    required IconData icon,
    required Color color,
    required String title,
    required List<String> steps,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(steps.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}.',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.45),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Text(
              'Butuh bantuan lain? Hubungi pengembang aplikasi.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}