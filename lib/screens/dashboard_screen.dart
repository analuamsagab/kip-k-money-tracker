import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../config/app_config.dart';
import '../extensions/number_format.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/icon_helper.dart';
import '../widgets/month_picker_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToTransactions;
  final VoidCallback? onNavigateToTahan;
  const DashboardScreen({super.key, this.onNavigateToTransactions, this.onNavigateToTahan});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  double _totalIncome = 0;
  double _totalExpense = 0;
  double _cashBalance = 0;
  double _ewalletBalance = 0;
  List<Transaction> _recentTransactions = [];
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  Map<int, double> _expenseByCategory = {};
  DateTime _categoryMonth = DateTime.now();
  bool _categoryFilterAll = true;
  SemesterSetting? _semester;
  MonthlyAllocation? _allocation;
  double _jajanUsed = 0;
  bool _loading = true;

  late final AppDatabase _db;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
    _loadData();
  }

  Future<void> _loadData() async {
    final now = DateTime.now();
    final income = await _db.getTotalIncomeAllTime();
    final expense = await _db.getTotalExpenseAllTime();
    final cash = await _db.getBalanceByMethod('cash');
    final ewallet = await _db.getBalanceByMethod('ewallet');
    final txs = await _db.getAllTransactions();
    final cats = await _db.getAllCategories();

    final semester = await _db.getActiveSemester();
    MonthlyAllocation? allocation;
    var jajanUsed = 0.0;
    if (semester != null) {
      allocation = await _db.getAllocationByMonth(now.month, now.year, semester.id);
      if (allocation != null) {
        jajanUsed = await _db.getTotalJajanUsed(now.month, now.year);
      }
    }

    setState(() {
      _totalIncome = income;
      _totalExpense = expense;
      _cashBalance = cash;
      _ewalletBalance = ewallet;
      _recentTransactions = txs.take(5).toList();
      _transactions = txs;
      _categories = cats;
      _expenseByCategory = _computeExpenseByCategory();
      _semester = semester;
      _allocation = allocation;
      _jajanUsed = jajanUsed;
      _loading = false;
    });
  }

  Map<int, double> _computeExpenseByCategory() {
    final result = <int, double>{};
    for (final t in _transactions) {
      if (t.type != 'expense') continue;
      if (!_categoryFilterAll &&
          (t.date.year != _categoryMonth.year ||
              t.date.month != _categoryMonth.month)) {
        continue;
      }
      result.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return result;
  }

  void _setCategoryFilter({required bool all, DateTime? month}) {
    setState(() {
      _categoryFilterAll = all;
      if (month != null) _categoryMonth = month;
      _expenseByCategory = _computeExpenseByCategory();
    });
  }

  Future<void> _pickCategoryMonth() async {
    final picked = await showMonthPickerSheet(
      context,
      initialYear: _categoryMonth.year,
      initialMonth: _categoryMonth.month,
    );
    if (picked != null) {
      _setCategoryFilter(all: false, month: picked);
    }
  }

  String get _categoryPeriodLabel =>
      _categoryFilterAll ? 'Semua waktu' : DateFormat('MMMM yyyy').format(_categoryMonth);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                children: [
                  _buildGradientHeader(),
                  _buildCardsSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildGradientHeader() {
    final auth = ref.watch(authProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(AppConfig.primaryColor),
            const Color(AppConfig.primaryColor).withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingRow(auth),
          const SizedBox(height: 24),
          _buildBalanceAnimated(),
          const SizedBox(height: 20),
          _buildIncomeExpenseRow(),
        ],
      ),
    );
  }

  Widget _buildGreetingRow(AuthState auth) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Selamat Pagi' : hour < 15 ? 'Selamat Siang' : 'Selamat Sore';
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset('assets/images/logo.png', width: 28, height: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                auth.isSignedIn ? '$greeting, ${auth.displayName}' : greeting,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (auth.isSignedIn && auth.email.isNotEmpty)
                Text(auth.email, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceAnimated() {
    final balance = _cashBalance + _ewalletBalance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sisa Duit Kamu', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: balance),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Text(
              formatRupiah(value),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            );
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _methodChip(Icons.payments, 'Cash', _cashBalance),
            const SizedBox(width: 10),
            _methodChip(Icons.account_balance_wallet, 'E-Wallet', _ewalletBalance),
          ],
        ),
      ],
    );
  }

  Widget _methodChip(IconData icon, String label, double amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatRupiah(amount),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseRow() {
    return Row(
      children: [
        _miniCard(
          icon: Icons.arrow_downward,
          iconColor: Colors.green,
          label: 'Pemasukan',
          amount: _totalIncome,
        ),
        const SizedBox(width: 12),
        _miniCard(
          icon: Icons.arrow_upward,
          iconColor: Colors.red,
          label: 'Pengeluaran',
          amount: _totalExpense,
        ),
      ],
    );
  }

  Widget _miniCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required double amount,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(
                    formatRupiah(amount),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: iconColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTahanStatsCard() {
    if (_semester == null || _allocation == null) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: widget.onNavigateToTahan,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(AppConfig.primaryColor).withValues(alpha: 0.06),
                  Colors.white,
                ],
              ),
              border: Border.all(color: const Color(AppConfig.primaryColor).withValues(alpha: 0.15)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(AppConfig.primaryColor).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shield, color: Color(AppConfig.primaryColor), size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Jatah Jajan Bulan Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.chevron_right, color: Color(AppConfig.primaryColor), size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sisa Jatah Jajan',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(0),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey[400],
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _statBlock('Jatah Jajan', formatRupiah(0), Colors.orange[700]!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statBlock('Terpakai', formatRupiah(0), Colors.red),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: 0,
                    backgroundColor: Colors.grey[200],
                    color: Colors.grey[400],
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ayo atur pengeluaranmu',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(AppConfig.primaryColor)),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ketuk panel ini untuk mengaktifkan fitur Tahan pengeluaranmu',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.3),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final jajan = _allocation!.totalJatahJajan;
    final sisa = jajan - _jajanUsed;
    final pct = jajan > 0 ? (_jajanUsed / jajan).clamp(0.0, 1.0) : 0.0;
    final barColor = pct > 0.8 ? Colors.red : pct > 0.6 ? Colors.orange : Colors.green;
    final sisaColor = sisa < 0 ? Colors.red : Colors.green[700]!;

    final card = Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: widget.onNavigateToTahan,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(AppConfig.primaryColor).withValues(alpha: 0.06),
                Colors.white,
              ],
            ),
            border: Border.all(color: const Color(AppConfig.primaryColor).withValues(alpha: 0.15)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConfig.primaryColor).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield, color: Color(AppConfig.primaryColor), size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Jatah Jajan Bulan Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  const Icon(Icons.chevron_right, color: Color(AppConfig.primaryColor), size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Sisa Jatah Jajan',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                formatRupiah(sisa),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: sisaColor,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _statBlock('Jatah Jajan', formatRupiah(jajan), Colors.orange[700]!),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statBlock('Terpakai', formatRupiah(_jajanUsed), Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: pct,
                  backgroundColor: Colors.grey[200],
                  color: barColor,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(pct * 100).toStringAsFixed(0)}% terpakai',
                style: TextStyle(fontSize: 11, color: pct > 0.8 ? Colors.red : Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );

    return card;
  }

  Widget _statBlock(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryHeader() {
    final now = DateTime.now();
    final isThisMonth = !_categoryFilterAll &&
        _categoryMonth.year == now.year &&
        _categoryMonth.month == now.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pengeluaran per Kategori', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(
          _categoryPeriodLabel,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Semua'),
              selected: _categoryFilterAll,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selectedColor: const Color(AppConfig.primaryColor).withValues(alpha: 0.12),
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              onSelected: (_) => _setCategoryFilter(all: true),
            ),
            ChoiceChip(
              label: const Text('Bulan Ini'),
              selected: isThisMonth,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selectedColor: const Color(AppConfig.primaryColor).withValues(alpha: 0.12),
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              onSelected: (_) => _setCategoryFilter(all: false, month: now),
            ),
            ChoiceChip(
              label: const Text('Pilih Bulan…'),
              selected: !_categoryFilterAll && !isThisMonth,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selectedColor: const Color(AppConfig.primaryColor).withValues(alpha: 0.12),
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              onSelected: (_) => _pickCategoryMonth(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    if (_expenseByCategory.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _categoryHeader(),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    _categoryFilterAll
                        ? 'Belum ada pengeluaran'
                        : 'Belum ada pengeluaran di ${DateFormat('MMMM yyyy').format(_categoryMonth)}',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final entries = _expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold(0.0, (sum, e) => sum + e.value);
    final catMap = {for (final c in _categories) c.id: c};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _categoryHeader(),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: entries.map((e) {
                          final cat = catMap[e.key];
                          return PieChartSectionData(
                            value: e.value,
                            color: cat != null ? Color(cat.color) : Colors.grey,
                            radius: 50,
                            title: '${(e.value / total * 100).toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entries.take(5).map((e) {
                      final cat = catMap[e.key];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 10, height: 10, decoration: BoxDecoration(color: cat != null ? Color(cat.color) : Colors.grey, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text('${cat?.name ?? '?'}: ${(e.value / total * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final catMap = {for (final c in _categories) c.id: c};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transaksi Terbaru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: widget.onNavigateToTransactions, child: const Text('Lihat Semua')),
              ],
            ),
            if (_recentTransactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: Text('Belum ada transaksi', style: TextStyle(color: Colors.grey[500]))),
              )
            else
              ..._recentTransactions.map((t) {
                final cat = catMap[t.categoryId];
                return ListTile(
                  dense: true,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cat != null ? Color(cat.color).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      cat != null ? getCategoryIcon(cat.icon) : Icons.category,
                      color: cat != null ? Color(cat.color) : Colors.grey,
                      size: 18,
                    ),
                  ),
                  title: Text(t.description.isNotEmpty ? t.description : (cat?.name ?? 'Unknown'), style: const TextStyle(fontSize: 14)),
                  subtitle: Text(DateFormat('dd/MM/yy').format(t.date), style: const TextStyle(fontSize: 11)),
                  trailing: Text(
                    '${t.type == 'income' ? '+' : '-'}${formatRupiah(t.amount)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: t.type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildTahanStatsCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildPieChart()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRecentTransactions()),
                  ],
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildTahanStatsCard(),
              const SizedBox(height: 20),
              _buildPieChart(),
              const SizedBox(height: 20),
              _buildRecentTransactions(),
            ],
          ),
        );
      },
    );
  }
}
