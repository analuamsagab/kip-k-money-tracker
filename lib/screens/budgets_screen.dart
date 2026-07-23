import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../extensions/number_format.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/icon_helper.dart';
import '../widgets/gradient_app_bar.dart';

class BudgetsScreen extends ConsumerStatefulWidget {
  const BudgetsScreen({super.key});

  @override
  ConsumerState<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends ConsumerState<BudgetsScreen> {
  late final AppDatabase _db;
  List<Category> _categories = [];
  List<Budget> _budgets = [];
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _load();
  }

  Future<void> _load() async {
    final cats = await _db.getAllCategories();
    final budgets = await _db.getBudgetsByMonth(_month, _year);
    setState(() {
      _categories = cats.where((c) => c.type == 'expense').toList();
      _budgets = budgets;
    });
  }

  void _showSetBudgetDialog(Category cat) {
    final existing = _budgets.where((b) => b.categoryId == cat.id).firstOrNull;
    final controller = TextEditingController(text: existing?.amount.toStringAsFixed(0) ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Budget ${cat.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Target Budget', prefixText: 'Rp ', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          if (existing != null)
            TextButton(
              onPressed: () async {
                await _db.deleteBudget(existing.id);
                Navigator.pop(ctx);
                _load();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          FilledButton(
            onPressed: () async {
              final amount = tryParseRupiahInput(controller.text);
              if (amount == null || amount <= 0) return;
              if (existing != null) {
                await _db.updateBudget(existing.id, BudgetsCompanion(amount: Value(amount)));
              } else {
                await _db.insertBudget(BudgetsCompanion.insert(
                  categoryId: cat.id,
                  amount: amount,
                  month: _month,
                  year: _year,
                ));
              }
              Navigator.pop(ctx);
              _load();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final budgetMap = {for (final b in _budgets) b.categoryId: b};

    return Scaffold(
      appBar: gradientAppBar(title: 'Target Budget'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('${DateFormat('MMMM').format(DateTime(_year, _month))} $_year',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: () { setState(() { _month--; if (_month == 0) { _month = 12; _year--; } }); _load(); }, icon: const Icon(Icons.chevron_left)),
                      Text(_month == DateTime.now().month && _year == DateTime.now().year ? 'Bulan Ini' : ''),
                      IconButton(onPressed: () { setState(() { _month++; if (_month == 13) { _month = 1; _year++; } }); _load(); }, icon: const Icon(Icons.chevron_right)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._categories.map((cat) {
            final budget = budgetMap[cat.id];
            return Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Color(cat.color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(getCategoryIcon(cat.icon), color: Color(cat.color), size: 20),
                ),
                title: Text(cat.name),
                subtitle: budget != null ? Text('Target: ${formatRupiah(budget.amount)}') : const Text('Belum ada target', style: TextStyle(fontStyle: FontStyle.italic)),
                trailing: const Icon(Icons.edit, size: 18),
                onTap: () => _showSetBudgetDialog(cat),
              ),
            );
          }),
        ],
      ),
    );
  }
}
