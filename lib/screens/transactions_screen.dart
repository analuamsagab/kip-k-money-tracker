import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../extensions/number_format.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/app_bottom_sheets.dart';
import '../widgets/icon_helper.dart';
import '../widgets/gradient_app_bar.dart';
import 'add_transaction_screen.dart';
import 'transfer_sheet.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  late final AppDatabase _db;
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  bool _loading = true;
  String? _filterType;
  int? _filterMonth;
  int? _filterYear;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _loadData();
  }

  Future<void> _loadData() async {
    final cats = await _db.getAllCategories();
    List<Transaction> txs;
    if (_filterMonth != null && _filterYear != null) {
      txs = await _db.getTransactionsByMonth(_filterMonth!, _filterYear!);
    } else if (_filterType != null) {
      txs = await _db.getTransactionsByType(_filterType!);
    } else {
      txs = await _db.getAllTransactions();
    }
    setState(() {
      _transactions = txs;
      _categories = cats;
      _loading = false;
    });
  }

  void _showFilterSheet() {
    showAppBottomSheet<void>(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHeader(
            title: 'Filter Transaksi',
            subtitle: 'Pilih jenis transaksi yang ingin ditampilkan.',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _filterChip('Semua', _filterType == null, () {
                  setState(() => _filterType = null);
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _filterChip('Pemasukan', _filterType == 'income', () {
                  setState(() => _filterType = 'income');
                  Navigator.pop(context);
                }),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _filterChip('Pengeluaran', _filterType == 'expense', () {
                  setState(() => _filterType = 'expense');
                  Navigator.pop(context);
                }),
              ),
            ],
          ),
        ],
      ),
    ).then((_) => _loadData());
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return SizedBox(
      height: 52,
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catMap = {for (final c in _categories) c.id: c};
    final income = _transactions.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount);
    final expense = _transactions.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount);

    return Scaffold(
      appBar: gradientAppBar(
        title: 'Riwayat Transaksi',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz, color: Colors.white),
            tooltip: 'Pindah Uang',
            onPressed: () async {
              final moved = await showAppBottomSheet<bool>(
                context,
                child: const TransferSheet(),
              );
              if (moved == true && mounted) {
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Uang berhasil dipindahkan')),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
          _loadData();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text('Total Masuk', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(formatRupiah(income), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text('Total Keluar', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(formatRupiah(expense), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                const Text('Selisih', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                Text(formatRupiah(income - expense), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text('${_transactions.length} transaksi', style: const TextStyle(color: Colors.grey)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _showFilterSheet,
                        tooltip: 'Filter',
                      ),
                    ],
                  ),
                  if (_transactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            Text('Belum ada transaksi', style: TextStyle(color: Colors.grey[500])),
                            const SizedBox(height: 8),
                            Text('Tap + untuk menambah transaksi', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._transactions.map((t) {
                      final cat = catMap[t.categoryId];
                      return Dismissible(
                        key: Key(t.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) async {
                          await _db.deleteTransaction(t.id);
                          _loadData();
                        },
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cat != null ? Color(cat.color).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cat != null ? getCategoryIcon(cat.icon) : Icons.receipt,
                              color: cat != null ? Color(cat.color) : Colors.grey,
                              size: 20,
                            ),
                          ),
                          title: Text(t.description.isNotEmpty ? t.description : (cat?.name ?? 'Unknown'), style: const TextStyle(fontSize: 14)),
                          subtitle: Row(
                            children: [
                              Text(DateFormat('dd/MM/yy').format(t.date), style: const TextStyle(fontSize: 11)),
                              const SizedBox(width: 8),
                              Icon(
                                t.paymentMethod == 'cash' ? Icons.payments : Icons.account_balance_wallet,
                                size: 12,
                                color: Colors.grey[500],
                              ),
                              if (t.isAutoImported) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('📧', style: TextStyle(fontSize: 10)),
                                ),
                              ],
                              if (t.integratedToBudget == true) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: t.budgetIntegrationType == 'semester'
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t.budgetIntegrationType == 'semester' ? 'Semester' : 'Jajan',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: t.budgetIntegrationType == 'semester' ? Colors.blue : Colors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(
                            '${t.type == 'income' ? '+' : '-'}${formatRupiah(t.amount)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: t.type == 'income' ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
