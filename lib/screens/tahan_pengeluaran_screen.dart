import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../extensions/number_format.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/gradient_app_bar.dart';

class TahanPengeluaranScreen extends ConsumerStatefulWidget {
  const TahanPengeluaranScreen({super.key});

  @override
  ConsumerState<TahanPengeluaranScreen> createState() => _TahanPengeluaranScreenState();
}

class _TahanPengeluaranScreenState extends ConsumerState<TahanPengeluaranScreen> with SingleTickerProviderStateMixin {
  late final AppDatabase _db;
  late TabController _tabController;

  SemesterSetting? _semester;
  MonthlyAllocation? _allocation;
  List<MonthlyNeed> _needs = [];
  List<MonthlyAllocation> _allAllocations = [];
  double _jajanUsed = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _db.deactivatePastSemesters();
    final semester = await _db.getActiveSemester();
    MonthlyAllocation? allocation;
    List<MonthlyNeed> needs = [];
    List<MonthlyAllocation> allAllocations = [];

    double jajanUsed = 0;
    if (semester != null) {
      final now = DateTime.now();
      allocation = await _db.getAllocationByMonth(now.month, now.year, semester.id);
      if (allocation != null) {
        needs = await _db.getNeedsByAllocation(allocation.id);
        jajanUsed = await _db.getTotalJajanUsed(now.month, now.year);
      }
      allAllocations = await _db.getAllocationsBySemester(semester.id);

      // Stimulus defisit: if previous month had deficit, reduce this month
      if (allocation != null) {
        final prevMonth = now.month == 1 ? 12 : now.month - 1;
        final prevYear = now.month == 1 ? now.year - 1 : now.year;
        final prevAlloc = await _db.getAllocationByMonth(prevMonth, prevYear, semester.id);
        if (prevAlloc != null) {
          final prevNeeds = await _db.getNeedsByAllocation(prevAlloc.id);
          final totalActual = prevNeeds
              .where((n) => n.isCompleted)
              .fold(0.0, (s, n) => s + (n.actualAmount ?? 0));
          if (totalActual > prevAlloc.monthlyAmount) {
            allocation = allocation.copyWith(
              monthlyAmount: allocation.monthlyAmount - (totalActual - prevAlloc.monthlyAmount),
            );
          }
        }
      }
    }

    setState(() {
      _semester = semester;
      _allocation = allocation;
      _needs = needs;
      _allAllocations = allAllocations;
      _jajanUsed = jajanUsed;
      _loading = false;
    });
  }

  void _showSemesterDialog() {
    if (_semester != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masih ada semester aktif. Selesaikan periode ini dulu.')),
      );
      return;
    }

    final controller = TextEditingController();
    final now = DateTime.now();
    int startMonth = now.month;
    int startYear = now.year;
    int duration = 6;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Input Uang Semester'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Total Uang Semester', prefixText: 'Rp ', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                key: const ValueKey('month'),
                initialValue: startMonth,
                decoration: const InputDecoration(labelText: 'Bulan Mulai', border: OutlineInputBorder()),
                items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(DateFormat('MMMM').format(DateTime(2020, i + 1))))),
                onChanged: (v) => setDialogState(() => startMonth = v ?? startMonth),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                key: const ValueKey('duration'),
                initialValue: duration,
                decoration: const InputDecoration(labelText: 'Durasi (bulan)', border: OutlineInputBorder()),
                items: [3, 4, 5, 6].map((d) => DropdownMenuItem(value: d, child: Text('$d bulan'))).toList(),
                onChanged: (v) => setDialogState(() => duration = v ?? duration),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            FilledButton(
              onPressed: () async {
                final amount = tryParseRupiahInput(controller.text);
                if (amount == null || amount <= 0) return;
                await _db.insertSemester(SemesterSettingsCompanion.insert(
                  totalAmount: amount,
                  startMonth: startMonth,
                  startYear: startYear,
                  durationMonths: Value(duration),
                  createdAt: DateTime.now(),
                ));
                final sem = await _db.getActiveSemester();
                if (sem != null) {
                  final monthlyAmount = sem.totalAmount / sem.durationMonths;
                  for (int i = 0; i < sem.durationMonths; i++) {
                    int m = sem.startMonth + i;
                    int y = sem.startYear;
                    while (m > 12) { m -= 12; y++; }
                    await _db.insertAllocation(MonthlyAllocationsCompanion.insert(
                      semesterId: sem.id,
                      month: m,
                      year: y,
                      monthlyAmount: monthlyAmount,
                    ));
                  }
                }
                Navigator.pop(ctx);
                _loadData();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteSemesterDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semester?'),
        content: const Text('Semua data semester, alokasi bulanan, dan kebutuhan akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true || _semester == null) return;
    await _db.deleteSemesterCascade(_semester!.id);
    _loadData();
  }

  void _showAddNeedDialog() {
    final controller = TextEditingController();
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kebutuhan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Nama Kebutuhan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(labelText: 'Anggaran', prefixText: 'Rp ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              if (controller.text.isEmpty || budgetController.text.isEmpty) return;
              final budget = tryParseRupiahInput(budgetController.text);
              if (budget == null || budget <= 0) return;
              if (_allocation == null) return;
              await _db.insertNeed(MonthlyNeedsCompanion.insert(
                allocationId: _allocation!.id,
                name: controller.text,
                budgetedAmount: budget,
                createdAt: DateTime.now(),
              ));
              // Recalc jatah jajan after adding need
              await _recalcJajan();
              Navigator.pop(ctx);
              _loadData();
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  Future<void> _recalcJajan() async {
    if (_allocation == null) return;
    final allNeeds = await _db.getNeedsByAllocation(_allocation!.id);
    final totalBudgeted = allNeeds.fold(0.0, (s, n) => s + n.budgetedAmount);
    final baseJajan = _allocation!.monthlyAmount - totalBudgeted;
    final completed = allNeeds.where((n) => n.isCompleted);
    final surplus = completed.fold(0.0, (s, n) => s + max(0.0, n.budgetedAmount - (n.actualAmount ?? 0)));
    final deficit = completed.fold(0.0, (s, n) => s + max(0.0, (n.actualAmount ?? 0) - n.budgetedAmount));
    final newJajan = max(0.0, baseJajan + surplus - deficit);
    await _db.updateAllocation(_allocation!.id, MonthlyAllocationsCompanion(
      totalJatahJajan: Value(newJajan),
    ));
  }

  void _showCompleteNeedDialog(MonthlyNeed need) {
    final controller = TextEditingController(text: need.budgetedAmount.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Selesaikan: ${need.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Anggaran: Rp ${NumberFormat.decimalPattern('id').format(need.budgetedAmount)}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Real Pengeluaran', prefixText: 'Rp ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              final actual = tryParseRupiahInput(controller.text);
              if (actual == null || actual < 0) return;
              await _db.updateNeed(need.id, MonthlyNeedsCompanion(
                actualAmount: Value(actual),
                isCompleted: Value(true),
                completedDate: Value(DateTime.now()),
              ));
              await _recalcJajan();
              Navigator.pop(ctx);
              _loadData();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditNeedDialog(MonthlyNeed need) {
    final nameController = TextEditingController(text: need.name);
    final budgetController = TextEditingController(text: need.budgetedAmount.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kebutuhan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Kebutuhan', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: budgetController,
              decoration: const InputDecoration(labelText: 'Anggaran', prefixText: 'Rp ', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              if (nameController.text.isEmpty || budgetController.text.isEmpty) return;
              final budget = tryParseRupiahInput(budgetController.text);
              if (budget == null || budget <= 0) return;
              await _db.updateNeed(need.id, MonthlyNeedsCompanion(
                name: Value(nameController.text),
                budgetedAmount: Value(budget),
              ));
              await _recalcJajan();
              Navigator.pop(ctx);
              _loadData();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteNeedDialog(MonthlyNeed need) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus ${need.name}?'),
        content: const Text('Kebutuhan ini akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _db.deleteNeed(need.id);
              await _recalcJajan();
              Navigator.pop(ctx);
              _loadData();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  double _totalBudgeted() => _needs.fold(0.0, (s, n) => s + n.budgetedAmount);
  double _totalActual() => _needs.where((n) => n.isCompleted).fold(0.0, (s, n) => s + (n.actualAmount ?? 0));
  double _jatahJajan() => _allocation != null ? _allocation!.totalJatahJajan : 0;
  double _baseJajan() {
    if (_allocation == null) return 0;
    return max(0.0, _allocation!.monthlyAmount - _totalBudgeted());
  }
  double _surplusTotal() {
    final completed = _needs.where((n) => n.isCompleted);
    return completed.fold(0.0, (s, n) => s + max(0.0, n.budgetedAmount - (n.actualAmount ?? 0)));
  }
  double _deficitTotal() {
    final completed = _needs.where((n) => n.isCompleted);
    return completed.fold(0.0, (s, n) => s + max(0.0, (n.actualAmount ?? 0) - n.budgetedAmount));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradientAppBar(
        title: 'Tahan Pengeluaranmu',
        automaticallyImplyLeading: false,
        actions: [
          if (_semester != null) IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _showDeleteSemesterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Status'),
            Tab(text: 'Kebutuhan'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _semester == null
              ? _buildEmptyState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStatusTab(),
                    _buildNeedsTab(),
                    _buildHistoryTab(),
                  ],
                ),
      floatingActionButton: _semester != null && _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _showAddNeedDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            const Text('Belum ada data semester', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Input uang semester kamu dulu', style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _showSemesterDialog,
              icon: const Icon(Icons.add),
              label: const Text('Input Uang Semester'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab() {
    if (_allocation == null) {
      final now = DateTime.now();
      final alloc = _allAllocations.where((a) =>
        a.year == now.year && a.month == now.month).firstOrNull;
      if (alloc == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text('Belum ada alokasi untuk bulan ini', style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        );
      }
    }

    final budget = _allocation!.monthlyAmount;
    final needUsed = _totalActual();
    final jajan = _jatahJajan();
    final baseJajan = _baseJajan();
    final surplus = _surplusTotal();
    final deficit = _deficitTotal();
    final totalUsed = needUsed + _jajanUsed;
    final remaining = budget - totalUsed;
    final jajanSisa = jajan - _jajanUsed;
    final pct = budget > 0 ? (totalUsed / budget) : 0.0;
    final isAlert = pct > 0.8;
    final isOver = totalUsed > budget;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: isAlert ? Colors.red[50] : null,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(DateTime(_allocation!.year, _allocation!.month)),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_allocation!.monthlyAmount < budget) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Budget terpotong karena defisit bulan lalu',
                          style: TextStyle(color: Colors.orange[700], fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                _progressRow('Anggaran Bulanan', formatRupiah(budget), Colors.blue),
                const SizedBox(height: 12),
                _progressRow('Terpakai', formatRupiah(totalUsed), Colors.red),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Kebutuhan ${formatRupiah(needUsed)} + Jajan ${formatRupiah(_jajanUsed)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 12),
                _progressRow('Sisa', formatRupiah(remaining), remaining < 0 ? Colors.red : Colors.green),
                if (isOver) ...[
                  const SizedBox(height: 12),
                  _progressRow(
                    'Defisit',
                    formatRupiah(totalUsed - budget) + ' (stimulus bulan depan)',
                    Colors.red,
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _progressRow('Jatah Jajan Awal', formatRupiah(baseJajan), Colors.orange),
                      if (surplus > 0) ...[
                        const SizedBox(height: 4),
                        _progressRow('+ Hemat Kebutuhan', formatRupiah(surplus), Colors.green),
                      ],
                      if (deficit > 0) ...[
                        const SizedBox(height: 4),
                        _progressRow('- Boros Kebutuhan', formatRupiah(deficit), Colors.red),
                      ],
                      const Divider(height: 16),
                      _progressRow('Total Jatah Jajan', formatRupiah(jajan), Colors.green),
                      if (_jajanUsed > 0) ...[
                        const SizedBox(height: 4),
                        _progressRow('- Terpakai', formatRupiah(_jajanUsed), Colors.red),
                        const SizedBox(height: 4),
                        _progressRow('Sisa Jatah Jajan', formatRupiah(jajanSisa), jajanSisa < 0 ? Colors.red : Colors.green),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: pct.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[200],
                    color: pct > 0.8 ? Colors.red : pct > 0.6 ? Colors.orange : Colors.green,
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${(pct * 100).toStringAsFixed(0)}% terpakai',
                    style: TextStyle(color: isAlert ? Colors.red : Colors.grey[600])),
                if (isAlert) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text('Sisa budget menipis! Atur pengeluaranmu.', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildNeedsTab() {
    if (_allocation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text('Belum ada alokasi bulan ini', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      );
    }

    final pending = _needs.where((n) => !n.isCompleted).toList();
    final completed = _needs.where((n) => n.isCompleted).toList();
    final jajan = _jatahJajan();
    final baseJajan = _baseJajan();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _progressRow('Total Anggaran Kebutuhan', formatRupiah(_totalBudgeted()), Colors.blue),
                const SizedBox(height: 6),
                _progressRow('Sisa Anggaran → Jatah Jajan Awal', formatRupiah(baseJajan), Colors.orange),
                const SizedBox(height: 6),
                _progressRow('Final Jatah Jajan', formatRupiah(jajan), Colors.green),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_needs.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.checklist, size: 48, color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Text('Belum ada kebutuhan', style: TextStyle(color: Colors.grey[500])),
                  const SizedBox(height: 4),
                  Text('Tambahkan kebutuhan bulan ini', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ),
        ] else ...[
          if (pending.isNotEmpty) ...[
            const Text('Belum Selesai', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            ...pending.map((n) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.radio_button_unchecked, color: Colors.grey),
                    title: Text(n.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(formatRupiah(n.budgetedAmount), style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.edit, size: 18, color: Colors.grey[400]),
                          onPressed: () => _showEditNeedDialog(n),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    onTap: () => _showCompleteNeedDialog(n),
                    onLongPress: () => _showDeleteNeedDialog(n),
                  ),
                )),
            const SizedBox(height: 16),
          ],
          if (completed.isNotEmpty) ...[
            const Text('Selesai', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            ...completed.map((n) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(n.name, style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    subtitle: Text('Budget: ${formatRupiah(n.budgetedAmount)} | Real: ${formatRupiah((n.actualAmount ?? 0))}'),
                    trailing: Text(
                      n.actualAmount != null && n.actualAmount! < n.budgetedAmount
                          ? 'Hemat ${formatRupiah((n.budgetedAmount - n.actualAmount!))}'
                          : n.actualAmount != null && n.actualAmount! > n.budgetedAmount
                              ? 'Boros ${formatRupiah((n.actualAmount! - n.budgetedAmount))}'
                              : 'Pas',
                      style: TextStyle(
                        fontSize: 11,
                        color: n.actualAmount != null && n.actualAmount! <= n.budgetedAmount ? Colors.green : Colors.red,
                      ),
                    ),
                    onLongPress: () => _showDeleteNeedDialog(n),
                  ),
                )),
          ],
        ],
      ],
    );
  }

  Widget _buildHistoryTab() {
    if (_semester == null) {
      return const Center(child: Text('Belum ada data semester'));
    }

    return FutureBuilder<List<MonthlyAllocation>>(
      future: _db.getAllocationsBySemester(_semester!.id),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final allocations = snapshot.data!;
        if (allocations.isEmpty) return const Center(child: Text('Belum ada alokasi'));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan Semester', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Total: ${formatRupiah(_semester!.totalAmount)}'),
                    Text('Per Bulan: ${formatRupiah((_semester!.totalAmount / _semester!.durationMonths))}'),
                    Text('Durasi: ${_semester!.durationMonths} bulan (${DateFormat('MMMM yyyy').format(DateTime(_semester!.startYear, _semester!.startMonth))})'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...allocations.map((a) {
              final isCurrent = a.month == DateTime.now().month && a.year == DateTime.now().year;
              return Card(
                color: isCurrent ? Colors.blue[50] : null,
                child: ListTile(
                  leading: Icon(isCurrent ? Icons.circle : Icons.circle_outlined, color: isCurrent ? Colors.blue : Colors.grey, size: 16),
                  title: Text(DateFormat('MMMM yyyy').format(DateTime(a.year, a.month))),
                  subtitle: Text('Anggaran: ${formatRupiah(a.monthlyAmount)}'),
                  trailing: Text('Jajan: ${formatRupiah(a.totalJatahJajan)}', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
