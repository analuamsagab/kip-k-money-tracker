import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../extensions/number_format.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/app_bottom_sheets.dart';
import '../widgets/app_button.dart';
import '../config/app_config.dart';
import '../widgets/money_field.dart';

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

  void _showSemesterSheet() {
    if (_semester != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masih ada semester aktif. Selesaikan periode ini dulu.')),
      );
      return;
    }
    showAppBottomSheet<void>(
      context,
      child: _SemesterSheet(
        onSaved: () {
          _loadData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Semester berhasil dibuat')),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDeleteSemesterSheet() async {
    final confirm = await showAppBottomSheet<bool>(
      context,
      child: const ConfirmationSheet(
        title: 'Hapus Semester?',
        message: 'Semua data semester, alokasi bulanan, dan kebutuhan akan dihapus permanen.',
        confirmLabel: 'Hapus',
        isDanger: true,
        icon: Icons.delete_outline,
      ),
    );
    if (confirm != true || _semester == null) return;
    await _db.deleteSemesterCascade(_semester!.id);
    _loadData();
  }

  void _showAddNeedSheet() {
    showAppBottomSheet<void>(
      context,
      child: _NeedFormSheet(
        onSubmitted: (name, budget) async {
          if (_allocation == null) return;
          await _db.insertNeed(MonthlyNeedsCompanion.insert(
            allocationId: _allocation!.id,
            name: name,
            budgetedAmount: budget,
            createdAt: DateTime.now(),
          ));
          await _recalcJajan();
          _loadData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kebutuhan berhasil ditambahkan')),
            );
          }
        },
      ),
    );
  }

  void _showCompleteNeedSheet(MonthlyNeed need) {
    showAppBottomSheet<void>(
      context,
      child: _CompleteNeedSheet(
        need: need,
        onSubmitted: (actual) async {
          await _db.updateNeed(need.id, MonthlyNeedsCompanion(
            actualAmount: Value(actual),
            isCompleted: Value(true),
            completedDate: Value(DateTime.now()),
          ));
          await _recalcJajan();
          _loadData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kebutuhan selesai. Jatah jajan diperbarui')),
            );
          }
        },
      ),
    );
  }

  void _showEditNeedSheet(MonthlyNeed need) {
    showAppBottomSheet<void>(
      context,
      child: _NeedFormSheet(
        initialName: need.name,
        initialBudget: need.budgetedAmount,
        onSubmitted: (name, budget) async {
          await _db.updateNeed(need.id, MonthlyNeedsCompanion(
            name: Value(name),
            budgetedAmount: Value(budget),
          ));
          await _recalcJajan();
          _loadData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kebutuhan diperbarui')),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDeleteNeedSheet(MonthlyNeed need) async {
    final confirm = await showAppBottomSheet<bool>(
      context,
      child: ConfirmationSheet(
        title: 'Hapus ${need.name}?',
        message: 'Kebutuhan ini akan dihapus.',
        confirmLabel: 'Hapus',
        isDanger: true,
        icon: Icons.delete_outline,
      ),
    );
    if (confirm != true) return;
    await _db.deleteNeed(need.id);
    await _recalcJajan();
    _loadData();
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
            onPressed: _showDeleteSemesterSheet,
          ),
        ],
        bottom: _semester == null
            ? null
            : TabBar(
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
              onPressed: _showAddNeedSheet,
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(AppConfig.primaryColor).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield, size: 56, color: Color(AppConfig.primaryColor)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ayo Atur Pengeluaranmu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(AppConfig.primaryColor)),
            ),
            const SizedBox(height: 8),
            Text(
              'Aktifkan fitur Tahan dengan mengatur uang semestermu.\nJatah jajan bulananmu akan muncul di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(AppConfig.primaryColor),
                minimumSize: const Size(240, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                shadowColor: const Color(AppConfig.primaryColor).withValues(alpha: 0.35),
              ),
              onPressed: _showSemesterSheet,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Input Uang Semester', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
                          onPressed: () => _showEditNeedSheet(n),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    onTap: () => _showCompleteNeedSheet(n),
                    onLongPress: () => _showDeleteNeedSheet(n),
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
                    onLongPress: () => _showDeleteNeedSheet(n),
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
class _SemesterSheet extends ConsumerStatefulWidget {
  const _SemesterSheet({required this.onSaved});

  final VoidCallback onSaved;

  @override
  ConsumerState<_SemesterSheet> createState() => _SemesterSheetState();
}

class _SemesterSheetState extends ConsumerState<_SemesterSheet> {
  final _controller = TextEditingController();
  int _startMonth = DateTime.now().month;
  int _duration = 6;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSave => (double.tryParse(_controller.text.replaceAll('.', '')) ?? 0) > 0;

  Future<void> _save() async {
    if (!_canSave || _saving) return;
    setState(() => _saving = true);
    final amount = tryParseRupiahInput(_controller.text);
    try {
      final db = ref.read(appDatabaseProvider);
      await db.insertSemester(SemesterSettingsCompanion.insert(
        totalAmount: amount ?? 0,
        startMonth: _startMonth,
        startYear: DateTime.now().year,
        durationMonths: Value(_duration),
        createdAt: DateTime.now(),
      ));
      final sem = await db.getActiveSemester();
      if (sem != null) {
        final monthlyAmount = sem.totalAmount / sem.durationMonths;
        for (int i = 0; i < sem.durationMonths; i++) {
          int m = sem.startMonth + i;
          int y = sem.startYear;
          while (m > 12) {
            m -= 12;
            y++;
          }
          await db.insertAllocation(MonthlyAllocationsCompanion.insert(
            semesterId: sem.id,
            month: m,
            year: y,
            monthlyAmount: monthlyAmount,
          ));
        }
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
    if (mounted) Navigator.pop(context);
    widget.onSaved();
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    final primary = const Color(AppConfig.primaryColor);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      prefixIconColor: Colors.grey[500],
      filled: true,
      fillColor: Colors.grey[50],
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - t)),
          child: child,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHeader(
            title: 'Input Uang Semester',
            subtitle: 'Atur dana semester untuk mulai jatah jajan bulanan.',
          ),
          const SizedBox(height: 20),
          MoneyField(
            controller: _controller,
            label: 'Total Uang Semester',
            helperText: 'Masukkan total dana yang akan digunakan selama satu semester.',
            autofocus: true,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _startMonth,
            decoration: _fieldDecoration('Bulan Mulai', Icons.calendar_month_outlined),
            items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text(DateFormat('MMMM').format(DateTime(2020, i + 1))))),
            onChanged: (v) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() => _startMonth = v ?? _startMonth);
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _duration,
            decoration: _fieldDecoration('Durasi (bulan)', Icons.timelapse_outlined),
            items: [3, 4, 5, 6].map((d) => DropdownMenuItem(value: d, child: Text('$d bulan'))).toList(),
            onChanged: (v) {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() => _duration = v ?? _duration);
            },
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => AppPrimaryButton(
              label: 'Simpan',
              icon: Icons.check,
              loading: _saving,
              onPressed: _canSave ? _save : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedFormSheet extends ConsumerStatefulWidget {
  const _NeedFormSheet({this.initialName, this.initialBudget, required this.onSubmitted});

  final String? initialName;
  final double? initialBudget;
  final Future<void> Function(String name, double budget) onSubmitted;

  @override
  ConsumerState<_NeedFormSheet> createState() => _NeedFormSheetState();
}

class _NeedFormSheetState extends ConsumerState<_NeedFormSheet> {
  late final TextEditingController _nameController = TextEditingController(text: widget.initialName ?? '');
  late final TextEditingController _budgetController =
      TextEditingController(text: widget.initialBudget != null ? groupedAmount(widget.initialBudget!) : '');

  bool get _isEdit => widget.initialName != null;

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty || _budgetController.text.isEmpty) return;
    final budget = tryParseRupiahInput(_budgetController.text);
    if (budget == null || budget <= 0) return;
    await widget.onSubmitted(_nameController.text.trim(), budget);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(AppConfig.primaryColor);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetHeader(title: _isEdit ? 'Edit Kebutuhan' : 'Tambah Kebutuhan'),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: 'Nama Kebutuhan',
            prefixIcon: const Icon(Icons.category_outlined, size: 20),
            prefixIconColor: Colors.grey[500],
            filled: true,
            fillColor: Colors.grey[50],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primary, width: 1.6),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          autofocus: !_isEdit,
        ),
        const SizedBox(height: 16),
        MoneyField(
          controller: _budgetController,
          label: 'Anggaran',
          helperText: 'Estimasi biaya untuk kebutuhan ini.',
        ),
        const SizedBox(height: 24),
        SheetActions(
          onConfirm: _submit,
          confirmLabel: _isEdit ? 'Simpan' : 'Tambah',
          confirmIcon: _isEdit ? Icons.save_outlined : Icons.add,
        ),
      ],
    );
  }
}

class _CompleteNeedSheet extends ConsumerStatefulWidget {
  const _CompleteNeedSheet({required this.need, required this.onSubmitted});

  final MonthlyNeed need;
  final Future<void> Function(double actual) onSubmitted;

  @override
  ConsumerState<_CompleteNeedSheet> createState() => _CompleteNeedSheetState();
}

class _CompleteNeedSheetState extends ConsumerState<_CompleteNeedSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: groupedAmount(widget.need.budgetedAmount));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final actual = tryParseRupiahInput(_controller.text);
    if (actual == null || actual < 0) return;
    await widget.onSubmitted(actual);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SheetHeader(title: 'Selesaikan Kebutuhan'),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(AppConfig.primaryColor).withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.checklist, size: 18, color: Color(AppConfig.primaryColor)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.need.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                formatRupiah(widget.need.budgetedAmount),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(AppConfig.primaryColor)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MoneyField(
          controller: _controller,
          label: 'Real Pengeluaran',
          helperText: 'Jumlah yang benar-benar dikeluarkan untuk kebutuhan ini.',
          autofocus: true,
        ),
        const SizedBox(height: 24),
        SheetActions(
          onConfirm: _submit,
          confirmLabel: 'Simpan',
          confirmIcon: Icons.check,
        ),
      ],
    );
  }
}
