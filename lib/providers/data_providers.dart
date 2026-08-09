import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'database_provider.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getAllCategories();
});

final expenseCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getCategoriesByType('expense');
});

final incomeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getCategoriesByType('income');
});

final allTransactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getAllTransactions();
});

final activeSemesterProvider = FutureProvider<SemesterSetting?>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getActiveSemester();
});
