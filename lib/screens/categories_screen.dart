import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/icon_helper.dart';
import '../widgets/gradient_app_bar.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  late final AppDatabase _db;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _load();
  }

  Future<void> _load() async {
    final cats = await _db.getAllCategories();
    setState(() => _categories = cats);
  }

  @override
  Widget build(BuildContext context) {
    final income = _categories.where((c) => c.type == 'income').toList();
    final expense = _categories.where((c) => c.type == 'expense').toList();

    return Scaffold(
      appBar: gradientAppBar(title: 'Kategori'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(income, 'Pemasukan', Icons.arrow_downward, Colors.green),
          const SizedBox(height: 16),
          _section(expense, 'Pengeluaran', Icons.arrow_upward, Colors.red),
        ],
      ),
    );
  }

  Widget _section(List<Category> cats, String title, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            ...cats.map((c) => ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Color(c.color).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                    child: Icon(getCategoryIcon(c.icon), color: Color(c.color), size: 18),
                  ),
                  title: Text(c.name),
                  subtitle: c.isDefault ? const Text('Default', style: TextStyle(fontSize: 11)) : null,
                )),
          ],
        ),
      ),
    );
  }
}
