import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../config/app_config.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/app_bottom_sheets.dart';
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

  Future<void> _openForm({Category? category}) async {
    final result = await showAppBottomSheet<dynamic>(
      context,
      child: CategoryFormSheet(
        db: _db,
        category: category,
        existing: _categories,
      ),
    );
    if (result == 'delete' && category != null) {
      _deleteCategory(category);
    } else if (result == true) {
      _load();
    }
  }

  Future<void> _deleteCategory(Category c) async {
    final confirm = await showAppBottomSheet<bool>(
      context,
      child: const ConfirmationSheet(
        title: 'Hapus Kategori?',
        message: 'Kategori ini akan dihapus permanen. Lanjutkan?',
        confirmLabel: 'Hapus',
        isDanger: true,
        icon: Icons.delete_outline,
      ),
    );
    if (confirm != true) return;

    final txCount = await _db.countTransactionsByCategory(c.id);
    if (txCount > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kategori masih dipakai $txCount transaksi. Ubah kategorinya dulu sebelum menghapus.',
            ),
          ),
        );
      }
      return;
    }
    final budgetCount = await _db.countBudgetsByCategory(c.id);
    if (budgetCount > 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori masih dipakai target budget. Hapus budget-nya dulu.')),
        );
      }
      return;
    }

    await _db.deleteCategory(c.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori "${c.name}" dihapus')),
      );
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final income = _categories.where((c) => c.type == 'income').toList();
    final expense = _categories.where((c) => c.type == 'expense').toList();

    return Scaffold(
      appBar: gradientAppBar(title: 'Kategori'),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openForm(),
      ),
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
                    decoration: BoxDecoration(
                      color: Color(c.color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(getCategoryIcon(c.icon), color: Color(c.color), size: 18),
                  ),
                  title: Text(c.name),
                  subtitle: c.isDefault
                      ? const Text('Default · tidak bisa dihapus', style: TextStyle(fontSize: 11))
                      : null,
                  trailing: Icon(Icons.edit_outlined, size: 18, color: Colors.grey[400]),
                  onTap: () => _openForm(category: c),
                )),
          ],
        ),
      ),
    );
  }
}

class CategoryFormSheet extends StatefulWidget {
  final AppDatabase db;
  final Category? category;
  final List<Category> existing;

  const CategoryFormSheet({
    super.key,
    required this.db,
    this.category,
    required this.existing,
  });

  @override
  State<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<CategoryFormSheet> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.category?.name ?? '');
  late String _type = widget.category?.type ?? 'expense';
  late String _icon = widget.category?.icon ?? 'more_horiz';
  late int _color =
      widget.category?.color ?? categoryColorOptions.first;
  bool _saving = false;

  bool get _isEdit => widget.category != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }
    final duplicate = widget.existing.any((c) =>
        c.type == _type &&
        c.id != widget.category?.id &&
        c.name.toLowerCase() == name.toLowerCase());
    if (duplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori dengan nama ini sudah ada')),
      );
      return;
    }

    setState(() => _saving = true);
    if (_isEdit) {
      await widget.db.updateCategory(
        widget.category!.id,
        CategoriesCompanion(
          name: Value(name),
          icon: Value(_icon),
          color: Value(_color),
        ),
      );
    } else {
      await widget.db.insertCategory(
        CategoriesCompanion.insert(
          name: name,
          icon: _icon,
          color: _color,
          type: _type,
        ),
      );
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetHeader(
          title: _isEdit ? 'Edit Kategori' : 'Tambah Kategori',
          subtitle: _isEdit
              ? 'Ubah nama, ikon, atau warna kategori.'
              : 'Kategori baru langsung tersedia di semua pilihan transaksi.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: 'Nama Kategori',
            hintText: 'contoh: Olahraga',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.label_outline, size: 20),
          ),
        ),
        const SizedBox(height: 16),
        if (!_isEdit) ...[
          const Text('Tipe', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'income',
                label: Text('Pemasukan'),
                icon: Icon(Icons.arrow_downward, size: 16),
              ),
              ButtonSegment(
                value: 'expense',
                label: Text('Pengeluaran'),
                icon: Icon(Icons.arrow_upward, size: 16),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor:
                  const Color(AppConfig.primaryColor).withValues(alpha: 0.12),
              selectedForegroundColor: const Color(AppConfig.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
        ],
        const Text('Ikon', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categoryIconNames.map((name) {
            final selected = _icon == name;
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => setState(() => _icon = name),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(AppConfig.primaryColor).withValues(alpha: 0.12)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: selected
                        ? const Color(AppConfig.primaryColor)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  getCategoryIcon(name),
                  size: 20,
                  color: selected
                      ? const Color(AppConfig.primaryColor)
                      : Colors.grey[700],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('Warna', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categoryColorOptions.map((colorValue) {
            final selected = _color == colorValue;
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _color = colorValue),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(colorValue),
                  shape: BoxShape.circle,
                  border: selected
                      ? Border.all(color: Colors.black38, width: 2.5)
                      : null,
                ),
                child: selected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_isEdit && !widget.category!.isDefault) ...[
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _saving ? null : () => Navigator.pop(context, 'delete'),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Hapus Kategori'),
            ),
          ),
          const SizedBox(height: 8),
        ],
        SheetActions(
          onCancel: () => Navigator.pop(context),
          onConfirm: _saving ? () {} : _save,
          confirmLabel: _isEdit ? 'Simpan Perubahan' : 'Tambah',
          confirmIcon: _isEdit ? Icons.check : Icons.add,
        ),
      ],
    );
  }
}