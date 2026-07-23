import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/auth_provider.dart';
import '../services/drive_backup_service.dart';
import 'categories_screen.dart';
import 'budgets_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final AppDatabase _db;
  final DriveBackupService _driveService = DriveBackupService();
  List<DriveBackupInfo> _backups = [];
  bool _loadingBackups = false;
  bool _uploading = false;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    ref.listen<AuthState>(authProvider, (_, next) {
      if (!next.isLoading && next.isSignedIn) _loadBackups();
      if (!next.isLoading && !next.isSignedIn) setState(() => _backups = []);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(authProvider);
      if (!current.isLoading && current.isSignedIn) _loadBackups();
    });
  }

  Future<void> _uploadBackup() async {
    setState(() => _uploading = true);
    try {
      final signIn = ref.read(authProvider.notifier).googleSignIn;
      final account = await signIn.signIn();
      if (account == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in dibatalkan')));
        return;
      }
      await _driveService.uploadBackup(signIn);
      await _loadBackups();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup berhasil diupload ke Google Drive')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal backup: $e')));
    }
    setState(() => _uploading = false);
  }

  Future<void> _loadBackups() async {
    setState(() => _loadingBackups = true);
    try {
      final signIn = ref.read(authProvider.notifier).googleSignIn;
      if (await signIn.isSignedIn()) {
        final backups = await _driveService.listBackups(signIn);
        setState(() => _backups = backups);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat backup: $e')));
    }
    setState(() => _loadingBackups = false);
  }

  Future<void> _restoreBackup(String fileId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Data?'),
        content: const Text('Data saat ini akan diganti dengan data dari backup. Lanjutkan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Restore')),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _restoring = true);
    try {
      final signIn = ref.read(authProvider.notifier).googleSignIn;
      await _driveService.downloadAndRestore(signIn, fileId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore berhasil! Tutup & buka ulang aplikasi.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal restore: $e')));
    }
    setState(() => _restoring = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(theme, authState),
          const SizedBox(height: 20),
          _sectionHeader('Cadangan Data'),
          _buildBackupCard(theme),
          if (_backups.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildBackupHistory(theme),
          ],
          const SizedBox(height: 24),
          _sectionHeader('Manajemen'),
          _buildManagementCard(theme),
          const SizedBox(height: 24),
          _sectionHeader('Tentang'),
          _buildAboutCard(theme),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileCard(ThemeData theme, AuthState authState) {
    if (authState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!authState.isSignedIn) {
      return Card(
        child: InkWell(
          onTap: () => ref.read(authProvider.notifier).signIn(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hubungkan Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text('Backup otomatis ke Google Drive', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: authState.photoUrl != null ? NetworkImage(authState.photoUrl!) : null,
              child: authState.photoUrl == null
                  ? Text(authState.displayName.isNotEmpty ? authState.displayName[0].toUpperCase() : '?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary))
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(authState.displayName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(authState.email, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.grey[600]),
              tooltip: 'Keluar',
              onPressed: () => ref.read(authProvider.notifier).signOut(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupCard(ThemeData theme) {
    final authState = ref.watch(authProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud_upload, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Google Drive', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              authState.isSignedIn ? 'Backup database ke Google Drive' : 'Sign in dulu untuk backup',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: authState.isSignedIn && !_uploading ? _uploadBackup : null,
                    icon: _uploading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.backup, size: 18),
                    label: Text(_uploading ? 'Mengupload...' : 'Backup Sekarang'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupHistory(ThemeData theme) {
    final authState = ref.watch(authProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Riwayat Backup', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                if (_loadingBackups)
                  const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _loadBackups,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Refresh',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_backups.isEmpty && !_loadingBackups)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(child: Text('Belum ada backup', style: TextStyle(color: Colors.grey[500]))),
              )
            else
              ...List.generate(_backups.length.clamp(0, 5), (i) {
                final b = _backups[i];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.backup, size: 18, color: theme.colorScheme.primary),
                  ),
                  title: Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(b.createdTime),
                    style: const TextStyle(fontSize: 13),
                  ),
                  subtitle: Text(
                    b.size > 0 ? '${(b.size / 1024).toStringAsFixed(0)} KB' : 'Unknown size',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: _restoring
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : IconButton(
                          icon: Icon(Icons.restore, size: 18, color: Colors.orange[700]),
                          tooltip: 'Restore',
                          onPressed: () => _restoreBackup(b.id),
                          visualDensity: VisualDensity.compact,
                        ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementCard(ThemeData theme) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(Icons.category, color: theme.colorScheme.primary),
            ),
            title: const Text('Kelola Kategori'),
            subtitle: const Text('Tambah, edit, hapus kategori transaksi'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen())),
          ),
          const Divider(height: 1, indent: 72),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.1),
              child: const Icon(Icons.track_changes, color: Colors.orange),
            ),
            title: const Text('Target Budget'),
            subtitle: const Text('Atur budget per kategori'),
            trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetsScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(ThemeData theme) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.1),
          child: Icon(Icons.info_outline, color: Colors.grey[600]),
        ),
        title: const Text(AppConfig.appName),
        subtitle: Text('v${AppConfig.appVersion}'),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () {},
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
    );
  }
}
