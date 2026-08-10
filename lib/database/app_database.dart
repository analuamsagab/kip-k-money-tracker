import 'dart:io';
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ================== TABLES ==================

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  TextColumn get type => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get description => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isAutoImported => boolean().withDefault(const Constant(false))();
  TextColumn? get emailMessageId => text().nullable()();
  BoolColumn? get integratedToBudget => boolean().nullable()();
  TextColumn? get budgetIntegrationType => text().nullable()();
  IntColumn? get targetSemesterId => integer().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant('cash'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

@DataClassName('WalletTransfer')
class WalletTransfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromMethod => text()();
  TextColumn get toMethod => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn? get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get amount => real()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
}

@DataClassName('SemesterSetting')
class SemesterSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get totalAmount => real()();
  IntColumn get startMonth => integer()();
  IntColumn get startYear => integer()();
  IntColumn get durationMonths => integer().withDefault(const Constant(6))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('MonthlyAllocation')
class MonthlyAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get semesterId => integer().references(SemesterSettings, #id)();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  RealColumn get monthlyAmount => real()();
  RealColumn get totalJatahJajan => real().withDefault(const Constant(0.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('MonthlyNeed')
class MonthlyNeeds extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get allocationId => integer().references(MonthlyAllocations, #id)();
  TextColumn get name => text()();
  RealColumn get budgetedAmount => real()();
  RealColumn? get actualAmount => real().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn? get completedDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// ================== DATABASE ==================

@DriftDatabase(
  tables: [
    Categories,
    Transactions,
    Budgets,
    SemesterSettings,
    MonthlyAllocations,
    MonthlyNeeds,
    WalletTransfers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(semesterSettings, semesterSettings.isActive);
          await m.addColumn(transactions, transactions.integratedToBudget);
          await m.addColumn(transactions, transactions.budgetIntegrationType);
          await m.addColumn(transactions, transactions.targetSemesterId);
        }
        if (from < 3) {
          await m.addColumn(transactions, transactions.paymentMethod);
          await m.createTable(walletTransfers);
          await customStatement(
            "UPDATE transactions SET payment_method = 'cash' WHERE payment_method IS NULL OR payment_method = ''",
          );
        }
      },
    );
  }

  // ========= SEED =========
  Future<void> _seedCategories() async {
    final defaultCategories = [
      (name: 'Makanan & Minuman', icon: 'restaurant', color: 0xFFE53935, type: 'expense'),
      (name: 'Transportasi', icon: 'directions_car', color: 0xFF1E88E5, type: 'expense'),
      (name: 'Belanja', icon: 'shopping_cart', color: 0xFFFB8C00, type: 'expense'),
      (name: 'Tagihan', icon: 'receipt_long', color: 0xFF43A047, type: 'expense'),
      (name: 'Hiburan', icon: 'movie', color: 0xFF8E24AA, type: 'expense'),
      (name: 'Kesehatan', icon: 'local_hospital', color: 0xFF00ACC1, type: 'expense'),
      (name: 'Pendidikan', icon: 'school', color: 0xFF5C6BC0, type: 'expense'),
      (name: 'Kos / Tempat Tinggal', icon: 'home', color: 0xFF6D4C41, type: 'expense'),
      (name: 'Lain-lain (Expense)', icon: 'more_horiz', color: 0xFF78909C, type: 'expense'),
      (name: 'Gaji', icon: 'work', color: 0xFF2E7D32, type: 'income'),
      (name: 'KIP-K', icon: 'card_giftcard', color: 0xFF1565C0, type: 'income'),
      (name: 'Freelance', icon: 'laptop', color: 0xFF6A1B9A, type: 'income'),
      (name: 'Lain-lain (Income)', icon: 'more_horiz', color: 0xFF78909C, type: 'income'),
    ];
    for (final cat in defaultCategories) {
      await into(categories).insert(CategoriesCompanion.insert(
        name: cat.name,
        icon: cat.icon,
        color: cat.color,
        type: cat.type,
        isDefault: const Value(true),
      ));
    }
  }

  // ========= CATEGORIES =========

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<List<Category>> getCategoriesByType(String type) =>
      (select(categories)..where((t) => t.type.equals(type))).get();

  Future<Category> getCategoryById(int id) =>
      (select(categories)..where((t) => t.id.equals(id))).getSingle();

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<int> updateCategory(int id, CategoriesCompanion entry) =>
      (update(categories)..where((t) => t.id.equals(id))).write(entry);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<int> countTransactionsByCategory(int categoryId) =>
      (selectOnly(transactions)
            ..addColumns([transactions.id.count()])
            ..where(transactions.categoryId.equals(categoryId)))
          .map((row) => row.read(transactions.id.count())!)
          .getSingle();

  Future<int> countBudgetsByCategory(int categoryId) =>
      (selectOnly(budgets)
            ..addColumns([budgets.id.count()])
            ..where(budgets.categoryId.equals(categoryId)))
          .map((row) => row.read(budgets.id.count())!)
          .getSingle();

  // ========= TRANSACTIONS =========

  Future<List<Transaction>> getAllTransactions() =>
      (select(transactions)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Future<List<Transaction>> getRecentTransactions({int limit = 5}) =>
      (select(transactions)..orderBy([(t) => OrderingTerm.desc(t.date)])..limit(limit)).get();

  Future<List<Transaction>> getTransactionsPaged(int page, {int perPage = 20}) =>
      (select(transactions)
            ..orderBy([(t) => OrderingTerm.desc(t.date)])
            ..limit(perPage, offset: (page - 1) * perPage))
          .get();

  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) =>
      (select(transactions)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByType(String type) =>
      (select(transactions)
            ..where((t) => t.type.equals(type))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<Transaction>> getTransactionsByMonth(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return getTransactionsByDateRange(start, end);
  }

  Future<double> getTotalIncomeByMonth(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final result = await (select(transactions)
          ..where((t) => t.type.equals('income') & t.date.isBetweenValues(start, end)))
        .map((t) => t.amount)
        .get();
    return result.fold<double>(0.0, (a, b) => a + b);
  }

  Future<double> getTotalExpenseByMonth(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final result = await (select(transactions)
          ..where((t) => t.type.equals('expense') & t.date.isBetweenValues(start, end)))
        .map((t) => t.amount)
        .get();
    return result.fold<double>(0.0, (a, b) => a + b);
  }

  Future<Transaction?> getTransactionByEmailId(String messageId) =>
      (select(transactions)..where((t) => t.emailMessageId.equals(messageId)))
          .getSingleOrNull();

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future<int> updateTransaction(int id, TransactionsCompanion entry) =>
      (update(transactions)..where((t) => t.id.equals(id))).write(entry);

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  // ========= BUDGETS =========

  Future<List<Budget>> getAllBudgets() => select(budgets).get();

  Future<List<Budget>> getBudgetsByMonth(int month, int year) =>
      (select(budgets)..where((t) => t.month.equals(month) & t.year.equals(year))).get();

  Future<Budget?> getBudgetByCategory(int categoryId, int month, int year) =>
      (select(budgets)
            ..where((t) => t.categoryId.equals(categoryId) & t.month.equals(month) & t.year.equals(year)))
          .getSingleOrNull();

  Future<int> insertBudget(BudgetsCompanion entry) => into(budgets).insert(entry);

  Future<int> updateBudget(int id, BudgetsCompanion entry) =>
      (update(budgets)..where((t) => t.id.equals(id))).write(entry);

  Future<int> deleteBudget(int id) =>
      (delete(budgets)..where((t) => t.id.equals(id))).go();

  // ========= SEMESTER SETTINGS =========

  Future<int> insertSemester(SemesterSettingsCompanion entry) =>
      into(semesterSettings).insert(entry);

  Future<int> updateSemester(int id, SemesterSettingsCompanion entry) =>
      (update(semesterSettings)..where((t) => t.id.equals(id))).write(entry);

  Future<int> deleteSemester(int id) =>
      (delete(semesterSettings)..where((t) => t.id.equals(id))).go();

  Future<void> deleteSemesterCascade(int semesterId) async {
    final allocations = await getAllocationsBySemester(semesterId);
    for (final a in allocations) {
      final needs = await getNeedsByAllocation(a.id);
      for (final n in needs) {
        await deleteNeed(n.id);
      }
      await (delete(monthlyAllocations)..where((t) => t.id.equals(a.id))).go();
    }
    await deleteSemester(semesterId);
  }

  // ========= MONTHLY ALLOCATIONS =========

  Future<List<MonthlyAllocation>> getAllocationsBySemester(int semesterId) =>
      (select(monthlyAllocations)..where((t) => t.semesterId.equals(semesterId))).get();

  Future<MonthlyAllocation?> getAllocationByMonth(int month, int year, int semesterId) =>
      (select(monthlyAllocations)
            ..where((t) => t.month.equals(month) & t.year.equals(year) & t.semesterId.equals(semesterId)))
          .getSingleOrNull();

  Future<MonthlyAllocation?> getActiveAllocation() async {
    final semester = await getActiveSemester();
    if (semester == null) return null;
    final now = DateTime.now();
    return getAllocationByMonth(now.month, now.year, semester.id);
  }

  Future<int> insertAllocation(MonthlyAllocationsCompanion entry) =>
      into(monthlyAllocations).insert(entry);

  Future<int> updateAllocation(int id, MonthlyAllocationsCompanion entry) =>
      (update(monthlyAllocations)..where((t) => t.id.equals(id))).write(entry);

  // ========= MONTHLY NEEDS (TO-DO) =========

  Future<List<MonthlyNeed>> getNeedsByAllocation(int allocationId) =>
      (select(monthlyNeeds)..where((t) => t.allocationId.equals(allocationId))).get();

  Future<List<MonthlyNeed>> getPendingNeeds(int allocationId) =>
      (select(monthlyNeeds)
            ..where((t) => t.allocationId.equals(allocationId) & t.isCompleted.equals(false)))
          .get();

  Future<List<MonthlyNeed>> getCompletedNeeds(int allocationId) =>
      (select(monthlyNeeds)
            ..where((t) => t.allocationId.equals(allocationId) & t.isCompleted.equals(true)))
          .get();

  Future<MonthlyNeed?> getNeedById(int id) =>
      (select(monthlyNeeds)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertNeed(MonthlyNeedsCompanion entry) =>
      into(monthlyNeeds).insert(entry);

  Future<int> updateNeed(int id, MonthlyNeedsCompanion entry) =>
      (update(monthlyNeeds)..where((t) => t.id.equals(id))).write(entry);

  Future<int> deleteNeed(int id) =>
      (delete(monthlyNeeds)..where((t) => t.id.equals(id))).go();

  // ========= SEMESTER ACTIVE STATE =========

  Future<void> deactivatePastSemesters() async {
    final semesters = await select(semesterSettings).get();
    final now = DateTime.now();
    for (final sem in semesters) {
      if (!sem.isActive) continue;
      final allocations = await getAllocationsBySemester(sem.id);
      final allPast = allocations.every((a) =>
        a.year < now.year || (a.year == now.year && a.month < now.month));
      if (allPast) {
        await updateSemester(sem.id, SemesterSettingsCompanion(
          isActive: const Value(false),
        ));
      }
    }
  }

  Future<SemesterSetting?> getActiveSemester() =>
      (select(semesterSettings)..where((t) => t.isActive.equals(true)))
          .getSingleOrNull();

  Future<List<MonthlyAllocation>> getAllocationsByMonthYear(int month, int year) async {
    final sem = await getActiveSemester();
    if (sem == null) return [];
    final alloc = await getAllocationByMonth(month, year, sem.id);
    if (alloc == null) return [];
    return [alloc];
  }

  // ========= BUDGET INTEGRATION =========

  Future<void> addIncomeToSemester(int semesterId, double amount) async {
    final sem = await (select(semesterSettings)..where((t) => t.id.equals(semesterId))).getSingle();
    final newTotal = sem.totalAmount + amount;
    await updateSemester(semesterId, SemesterSettingsCompanion(
      totalAmount: Value(newTotal),
    ));
    // Recalculate all allocations with new per-month amount
    final allocations = await getAllocationsBySemester(semesterId);
    final perMonth = newTotal / sem.durationMonths;
    for (final a in allocations) {
      await updateAllocation(a.id, MonthlyAllocationsCompanion(
        monthlyAmount: Value(perMonth),
      ));
    }
  }

  Future<void> addToJajan(int allocationId, double amount) async {
    final alloc = await (select(monthlyAllocations)..where((t) => t.id.equals(allocationId))).getSingle();
    await updateAllocation(allocationId, MonthlyAllocationsCompanion(
      totalJatahJajan: Value(alloc.totalJatahJajan + amount),
    ));
  }

  Future<double> getTotalJajanUsed(int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final txs = await (select(transactions)
          ..where((t) => t.type.equals('expense'))
          ..where((t) => t.budgetIntegrationType.equals('jajan'))
          ..where((t) => t.date.isBetweenValues(start, end)))
        .get();
    return txs.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getMonthlyDeficit(int month, int year, int semesterId) async {
    final alloc = await getAllocationByMonth(month, year, semesterId);
    if (alloc == null) return 0;
    final needs = await getNeedsByAllocation(alloc.id);
    final totalActual = needs
        .where((n) => n.isCompleted)
        .fold(0.0, (s, n) => s + (n.actualAmount ?? 0));
    return max(0.0, totalActual - alloc.monthlyAmount);
  }

  // ========= PAYMENT METHOD / BALANCE =========

  Future<double> _sumByTypeAndMethod(String type, String method) async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equals(type) & transactions.paymentMethod.equals(method));
    final row = await query.getSingle();
    return row.read(transactions.amount.sum()) ?? 0;
  }

  Future<double> _sumTransferByMethod({
    required bool incoming,
    required String method,
  }) async {
    final col = incoming ? walletTransfers.toMethod : walletTransfers.fromMethod;
    final query = selectOnly(walletTransfers)
      ..addColumns([walletTransfers.amount.sum()])
      ..where(col.equals(method));
    final row = await query.getSingle();
    return row.read(walletTransfers.amount.sum()) ?? 0;
  }

  Future<double> getBalanceByMethod(String method) async {
    final income = await _sumByTypeAndMethod('income', method);
    final expense = await _sumByTypeAndMethod('expense', method);
    final transferIn = await _sumInByMethod(method);
    final transferOut = await _sumOutByMethod(method);
    return income - expense + transferIn - transferOut;
  }

  Future<double> _sumInByMethod(String method) =>
      _sumTransferByMethod(incoming: true, method: method);

  Future<double> _sumOutByMethod(String method) =>
      _sumTransferByMethod(incoming: false, method: method);

  Future<double> getTotalBalance() async {
    final cash = await getBalanceByMethod('cash');
    final ewallet = await getBalanceByMethod('ewallet');
    return cash + ewallet;
  }

  Future<double> getTotalIncomeAllTime() async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equals('income'));
    final row = await query.getSingle();
    return row.read(transactions.amount.sum()) ?? 0;
  }

  Future<double> getTotalExpenseAllTime() async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.amount.sum()])
      ..where(transactions.type.equals('expense'));
    final row = await query.getSingle();
    return row.read(transactions.amount.sum()) ?? 0;
  }

  // ========= WALLET TRANSFERS =========

  Future<int> insertTransfer(WalletTransfersCompanion entry) =>
      into(walletTransfers).insert(entry);

  Future<List<WalletTransfer>> getAllTransfers() =>
      (select(walletTransfers)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kipk_tracker.db'));
    return NativeDatabase(file);
  });
}
