import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import '../extensions/number_format.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/gradient_app_bar.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  const AddTransactionScreen({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late final AppDatabase _db;
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'expense';
  int? _categoryId;
  DateTime _date = DateTime.now();
  List<Category> _categories = [];

  // Budget integration
  SemesterSetting? _activeSemester;
  MonthlyAllocation? _currentAllocation;
  bool _integrateToBudget = false;
  String _integrationType = 'jajan';

  // Create new semester from income
  bool _createSemesterFromIncome = false;
  int _semesterDuration = 6;
  int _semesterStartMonth = DateTime.now().month;
  int _semesterStartYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _loadCategories();
    _loadSemester();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      _type = t.type;
      _categoryId = t.categoryId;
      _date = t.date;
      _descController.text = t.description;
      _amountController.text = t.amount.toStringAsFixed(0);
    }
  }

  Future<void> _loadCategories() async {
    final cats = await _db.getCategoriesByType(_type);
    setState(() => _categories = cats);
  }

  Future<void> _loadSemester() async {
    final sem = await _db.getActiveSemester();
    if (sem != null) {
      final now = DateTime.now();
      final alloc = await _db.getAllocationByMonth(now.month, now.year, sem.id);
      setState(() {
        _activeSemester = sem;
        _currentAllocation = alloc;
      });
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih kategori')));
      return;
    }
    final amount = parseRupiahInput(_amountController.text);
    final now = DateTime.now();

    if (widget.transaction != null) {
      await _db.updateTransaction(widget.transaction!.id, TransactionsCompanion(
        amount: Value(amount),
        type: Value(_type),
        categoryId: Value(_categoryId!),
        description: Value(_descController.text),
        date: Value(_date),
        updatedAt: Value(now),
      ));
    } else {
      // Handle creating new semester from income
      if (_type == 'income' && _createSemesterFromIncome && _activeSemester == null) {
        final semId = await _db.insertSemester(SemesterSettingsCompanion.insert(
          totalAmount: amount,
          startMonth: _semesterStartMonth,
          startYear: _semesterStartYear,
          durationMonths: Value(_semesterDuration),
          createdAt: now,
        ));
        final monthlyAmount = amount / _semesterDuration;
        for (int i = 0; i < _semesterDuration; i++) {
          int m = _semesterStartMonth + i;
          int y = _semesterStartYear;
          while (m > 12) { m -= 12; y++; }
          await _db.insertAllocation(MonthlyAllocationsCompanion.insert(
            semesterId: semId,
            month: m,
            year: y,
            monthlyAmount: monthlyAmount,
          ));
        }
        await _db.insertTransaction(TransactionsCompanion.insert(
          amount: amount,
          type: _type,
          categoryId: _categoryId!,
          description: _descController.text,
          date: _date,
          createdAt: now,
          updatedAt: now,
          integratedToBudget: const Value(true),
          budgetIntegrationType: const Value('semester'),
          targetSemesterId: Value(semId),
        ));
      } else {
        final canIntegrateExpense = _type == 'expense' && _currentAllocation != null;
        final canIntegrateIncome = _type == 'income' && _activeSemester != null;
        final integrate = _integrateToBudget && (canIntegrateExpense || canIntegrateIncome);
        final integrationType = integrate ? (_type == 'expense' ? 'jajan' : _integrationType) : null;
        await _db.insertTransaction(TransactionsCompanion.insert(
          amount: amount,
          type: _type,
          categoryId: _categoryId!,
          description: _descController.text,
          date: _date,
          createdAt: now,
          updatedAt: now,
          integratedToBudget: Value(integrate ? true : null),
          budgetIntegrationType: Value(integrationType),
          targetSemesterId: Value(integrate && _integrationType == 'semester' ? _activeSemester!.id : null),
        ));

        if (integrate) {
          if (_type == 'income') {
            if (_integrationType == 'semester') {
              await _db.addIncomeToSemester(_activeSemester!.id, amount);
            } else {
              await _db.addToJajan(_currentAllocation!.id, amount);
            }
          }
        }
      }
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradientAppBar(title: widget.transaction != null ? 'Edit Transaksi' : 'Tambah Transaksi'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: _typeChip('Pemasukan', 'income'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _typeChip('Pengeluaran', 'expense'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Isi nominal' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
                if (picked != null) setState(() => _date = picked);
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Tanggal', border: OutlineInputBorder()),
                child: Text(DateFormat('dd MMMM yyyy').format(_date)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              key: ValueKey(_type),
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _categoryId = v),
            ),

            // INCOME: no semester active -> option to create one
            if (_type == 'income' && _activeSemester == null && widget.transaction == null) ...[
              const SizedBox(height: 24),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Jadikan uang semester', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Aktifkan fitur Tahan Pengeluaranmu dari pemasukan ini', style: TextStyle(fontSize: 11)),
                value: _createSemesterFromIncome,
                onChanged: (v) => setState(() => _createSemesterFromIncome = v),
              ),
              if (_createSemesterFromIncome) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  key: const ValueKey('semester_duration'),
                  initialValue: _semesterDuration,
                  decoration: const InputDecoration(labelText: 'Durasi Semester', border: OutlineInputBorder()),
                  items: [3, 4, 5, 6].map((d) => DropdownMenuItem(value: d, child: Text('$d bulan'))).toList(),
                  onChanged: (v) => setState(() => _semesterDuration = v ?? 6),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  key: const ValueKey('semester_start'),
                  initialValue: _semesterStartMonth,
                  decoration: const InputDecoration(labelText: 'Bulan Mulai', border: OutlineInputBorder()),
                  items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(DateFormat('MMMM').format(DateTime(2020, i + 1))))),
                  onChanged: (v) => setState(() => _semesterStartMonth = v ?? DateTime.now().month),
                ),
              ],
            ],

            // INCOME: semester active -> integrate options
            if (_activeSemester != null && _type == 'income' && widget.transaction == null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Integrasikan ke Tahan Pengeluaranmu', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Uang ini akan masuk ke sistem budget', style: TextStyle(fontSize: 11)),
                value: _integrateToBudget,
                onChanged: (v) => setState(() => _integrateToBudget = v),
              ),
              if (_integrateToBudget) ...[
                const SizedBox(height: 8),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Tambah ke uang semester', style: TextStyle(fontSize: 13)),
                  subtitle: Text('Dibagi rata ke ${_activeSemester!.durationMonths} bulan', style: const TextStyle(fontSize: 11)),
                  value: 'semester',
                  groupValue: _integrationType,
                  onChanged: (v) => setState(() => _integrationType = v!),
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Tambah ke jatah jajan bulan ini', style: TextStyle(fontSize: 13)),
                  subtitle: const Text('Langsung nambah ke jatah jajan bulan berjalan', style: TextStyle(fontSize: 11)),
                  value: 'jajan',
                  groupValue: _integrationType,
                  onChanged: _currentAllocation != null
                      ? (v) => setState(() => _integrationType = v!)
                      : null,
                ),
              ],
            ],

            // EXPENSE: semester active -> reduce jajan
            if (_activeSemester != null && _type == 'expense' && widget.transaction == null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Kurangi jatah jajan', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Pengeluaran ini mengurangi jatah jajan bulan ini', style: TextStyle(fontSize: 11)),
                value: _integrateToBudget,
                onChanged: (v) => setState(() => _integrateToBudget = v),
              ),
            ],

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Simpan'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label, String type) {
    final selected = _type == type;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _type = type;
          _categoryId = null;
          _integrateToBudget = false;
          _createSemesterFromIncome = false;
        });
        _loadCategories();
      },
      selectedColor: type == 'income' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
    );
  }
}
