import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BackupService {
  Future<String> createBackup() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'kipk_tracker.db'));

    final now = DateTime.now();
    final backupName =
        'kipk_backup_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.db';
    final backupFile = File(p.join(dbFolder.path, backupName));

    await backupFile.writeAsBytes(await dbFile.readAsBytes());
    return backupFile.path;
  }

  Future<String> restoreBackup(String filePath) async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'kipk_tracker.db'));
    final backupFile = File(filePath);

    if (!await backupFile.exists()) {
      throw Exception('File backup tidak ditemukan');
    }

    await dbFile.writeAsBytes(await backupFile.readAsBytes());
    return dbFile.path;
  }

  Future<int> getBackupFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final bytes = await file.length();
      return bytes;
    }
    return 0;
  }
}
