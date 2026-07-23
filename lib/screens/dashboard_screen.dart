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

class DashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNavigateToTransactions;
  const DashboardScreen({super.key, this.onNavigateToTransactions});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<Transaction> _recentTransactions = [];
  List<Category> _categories = [];
  Map<int, double> _expenseByCategory = {};
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
    final income = await _db.getTotalIncomeByMonth(now.month, now.year);
    final expense = await _db.getTotalExpenseByMonth(now.month, now.year);
    final txs = await _db.getAllTransactions();
    final cats = await _db.getAllCategories();
    final catExpense = <int, double>{};
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 1);
    final monthTxs = txs.where((t) =>
        t.date.isAfter(start) && t.date.isBefore(end) && t.type == 'expense');
    for (final t in monthTxs) {
      catExpense.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    setState(() {
      _totalIncome = income;
      _totalExpense = expense;
      _recentTransactions = txs.take(5).toList();
      _categories = cats;
      _expenseByCategory = catExpense;
      _loading = false;
    });
  }

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
    final balance = _totalIncome - _totalExpense;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saldo Bulan Ini', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: balance),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return Text(
              formatRupiah(value),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            );
          },
        ),
      ],
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

  Widget _buildProgressRing() {
    final pct = _totalIncome > 0 ? (_totalExpense / _totalIncome).clamp(0.0, 1.0) : 0.0;
    final barColor = pct > 0.8 ? Colors.red : pct > 0.6 ? Colors.orange : Colors.green;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sisa Budget Bulan Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: pct,
                        color: barColor,
                        strokeWidth: 14,
                        backgroundColor: Colors.grey[200],
                      ),
                      Text(
                        '${((1 - pct) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: barColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _miniStat('Pemasukan', formatRupiah(_totalIncome), Colors.green),
                      const SizedBox(height: 6),
                      _miniStat('Pengeluaran', formatRupiah(_totalExpense), Colors.red),
                      const SizedBox(height: 6),
                      _miniStat('Sisa', formatRupiah(_totalIncome - _totalExpense), barColor),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
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
              const Text('Pengeluaran per Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: Center(
                  child: Text('Belum ada pengeluaran bulan ini', style: TextStyle(color: Colors.grey[500])),
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
            const Text('Pengeluaran per Kategori', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    Expanded(child: _buildProgressRing()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildPieChart()),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildRecentTransactions()),
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: _buildTahanCard()),
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
              _buildProgressRing(),
              const SizedBox(height: 20),
              _buildPieChart(),
              const SizedBox(height: 20),
              _buildRecentTransactions(),
              const SizedBox(height: 20),
              _buildTahanCard(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTahanCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(AppConfig.primaryColor).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.shield, color: Color(AppConfig.primaryColor), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Tahan Pengeluaranmu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Buka tab Tahan untuk atur anggaran semester', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
