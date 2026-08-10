import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DriveBackupInfo {
  final String id;
  final String name;
  final DateTime createdTime;
  final int size;

  DriveBackupInfo({
    required this.id,
    required this.name,
    required this.createdTime,
    required this.size,
  });
}

class DriveBackupService {
  static const _folderName = 'KIP-K Money Tracker Backups';

  Future<drive.DriveApi> _api(GoogleSignIn signIn) async {
    final authClient = await signIn.authenticatedClient();
    if (authClient == null) throw Exception('Gagal mendapatkan akses Google');
    return drive.DriveApi(authClient);
  }

  Future<String> _ensureBackupFolder(drive.DriveApi api) async {
    final existing = await api.files.list(
      q: "name='$_folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false",
      spaces: 'drive',
    );
    if (existing.files != null && existing.files!.isNotEmpty) {
      return existing.files!.first.id!;
    }
    final folder = await api.files.create(
      drive.File(name: _folderName, mimeType: 'application/vnd.google-apps.folder'),
    );
    return folder.id!;
  }

  Future<String> uploadBackup(GoogleSignIn signIn) async {
    final api = await _api(signIn);
    final folderId = await _ensureBackupFolder(api);

    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'kipk_tracker.db'));
    if (!await dbFile.exists()) throw Exception('Database tidak ditemukan');

    final now = DateTime.now();
    final backupName = 'kipk_backup_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}.db';

    final media = drive.Media(dbFile.openRead(), await dbFile.length());
    final file = await api.files.create(
      drive.File(name: backupName, parents: [folderId]),
      uploadMedia: media,
    );

    await _cleanupOldBackups(api, folderId);

    return file.id ?? '';
  }

  Future<List<DriveBackupInfo>> listBackups(GoogleSignIn signIn) async {
    final api = await _api(signIn);
    final folderId = await _ensureBackupFolder(api);

    final result = await api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      orderBy: 'createdTime desc',
      pageSize: 20,
      $fields: 'files(id, name, size, createdTime)',
    );

    final files = result.files ?? [];
    return files.map((f) => DriveBackupInfo(
      id: f.id ?? '',
      name: f.name ?? '',
      createdTime: f.createdTime ?? DateTime.now(),
      size: int.tryParse(f.size ?? '') ?? 0,
    )).toList();
  }

  Future<void> downloadAndRestore(GoogleSignIn signIn, String fileId) async {
    final api = await _api(signIn);
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'kipk_tracker.db'));

    final response = await api.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia);
    if (response is drive.Media) {
      final tempFile = File(p.join(dbFolder.path, 'kipk_restore_temp.db'));
      final sink = tempFile.openWrite();
      await response.stream.pipe(sink);
      await sink.flush();
      await sink.close();

      await dbFile.writeAsBytes(await tempFile.readAsBytes());
      await tempFile.delete();
    } else {
      throw Exception('Gagal mendownload backup');
    }
  }

  Future<void> deleteBackup(GoogleSignIn signIn, String fileId) async {
    final api = await _api(signIn);
    await api.files.delete(fileId);
  }

  Future<void> _cleanupOldBackups(drive.DriveApi api, String folderId) async {
    final result = await api.files.list(
      q: "'$folderId' in parents and trashed=false",
      spaces: 'drive',
      orderBy: 'createdTime desc',
      pageSize: 100,
    );
    final files = result.files ?? [];
    if (files.length <= 5) return;

    for (final f in files.skip(5)) {
      if (f.id != null) {
        await api.files.delete(f.id!);
      }
    }
  }
}
