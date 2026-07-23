import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../extensions/number_format.dart';
import '../widgets/icon_helper.dart';
import '../widgets/gradient_app_bar.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../database/app_database.dart';
import '../providers/database_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late final AppDatabase _db;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  double _income = 0;
  double _expense = 0;
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _loadData();
  }

  Future<void> _loadData() async {
    final income = await _db.getTotalIncomeByMonth(_selectedMonth, _selectedYear);
    final expense = await _db.getTotalExpenseByMonth(_selectedMonth, _selectedYear);
    final txs = await _db.getTransactionsByMonth(_selectedMonth, _selectedYear);
    final cats = await _db.getAllCategories();
    setState(() {
      _income = income;
      _expense = expense;
      _transactions = txs;
      _categories = cats;
      _loading = false;
    });
  }

  void _prevMonth() {
    setState(() {
      _selectedMonth--;
      if (_selectedMonth == 0) {
        _selectedMonth = 12;
        _selectedYear--;
      }
      _loading = true;
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth++;
      if (_selectedMonth == 13) {
        _selectedMonth = 1;
        _selectedYear++;
      }
      _loading = true;
    });
    _loadData();
  }

  Future<void> _exportCSV() async {
    final catMap = {for (final c in _categories) c.id: c};
    final rows = [
      ['Tanggal', 'Tipe', 'Kategori', 'Deskripsi', 'Nominal'],
      ..._transactions.map((t) {
        final cat = catMap[t.categoryId];
        return [
          DateFormat('dd/MM/yyyy').format(t.date),
          t.type == 'income' ? 'Pemasukan' : 'Pengeluaran',
          cat?.name ?? '',
          t.description,
          t.amount.toStringAsFixed(0),
        ];
      }),
    ];
    final csv = const ListToCsvConverter().convert(rows);

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'laporan_${_selectedMonth}_$_selectedYear.csv'));
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Laporan Keuangan ${_monthName()} $_selectedYear',
    );
  }

  String _monthName() {
    return DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    final catMap = {for (final c in _categories) c.id: c};

    // Expense by category
    final catExpense = <int, double>{};
    for (final t in _transactions.where((t) => t.type == 'expense')) {
      catExpense.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    final sortedCatExpense = catExpense.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: gradientAppBar(title: 'Laporan Keuangan', automaticallyImplyLeading: false),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: _prevMonth, icon: const Icon(Icons.chevron_left)),
                    Text('${_monthName()} $_selectedYear', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: _nextMonth, icon: const Icon(Icons.chevron_right)),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _summaryItem('Pemasukan', formatRupiah(_income), Colors.green),
                            _summaryItem('Pengeluaran', formatRupiah(_expense), Colors.red),
                            _summaryItem('Selisih', formatRupiah(_income - _expense), _income >= _expense ? Colors.green : Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rincian Pengeluaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (sortedCatExpense.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Center(child: Text('Tidak ada pengeluaran', style: TextStyle(color: Colors.grey[500]))),
                          )
                        else
                          ...sortedCatExpense.map((e) {
                            final cat = catMap[e.key];
                            final pct = _expense > 0 ? (e.value / _expense * 100) : 0;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: cat != null ? Color(cat.color).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(cat != null ? getCategoryIcon(cat.icon) : Icons.category, size: 16, color: cat != null ? Color(cat.color) : Colors.grey),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(cat?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 2),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: pct / 100,
                                            backgroundColor: Colors.grey[200],
                                            color: cat != null ? Color(cat.color) : Colors.grey,
                                            minHeight: 6,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(formatRupiah(e.value), style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Text('${pct.toStringAsFixed(1)}%', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _exportCSV,
                  icon: const Icon(Icons.download),
                  label: const Text('Export CSV'),
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _summaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
