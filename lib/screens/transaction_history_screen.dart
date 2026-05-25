import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../models/transaction_model.dart';
import '../services/dashboard_service.dart';
import '../services/transaction_service.dart';
import '../theme/app_colors.dart';
import '../utils/no_animation_route.dart';
import '../utils/app_formatters.dart';
import 'add_transaction_screen.dart';
import 'budget_settings_screen.dart';
import '../widgets/transaction_details_sheet.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final InMemoryDataStore _store = InMemoryDataStore.instance;
  final TransactionService _transactionService = TransactionService.instance;
  final DashboardService _dashboardService = DashboardService.instance;

  String searchQuery = '';
  String timeRangeType = 'bulan';
  String timeRangeValue = '';
  String typeFilter = '';
  String categoryFilter = '';
  String paymentFilter = '';

  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = DateTime(now.year, now.month);
    timeRangeValue = formatMonthYearKey(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final filteredTransactions = _transactionService.filterTransactions(
          searchQuery: searchQuery,
          timeRangeType: timeRangeType,
          timeRangeValue: timeRangeValue,
          typeFilter: typeFilter,
          categoryFilter: categoryFilter,
          paymentFilter: paymentFilter,
        );
        final groupedData = _transactionService.groupByLabel(
          filteredTransactions,
        );
        final summary = _dashboardService.getHistorySummary();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman Home
              },
            ),
            title: const Text(
              'Riwayat Transaksi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
                onPressed: () {},
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header: Summary Cards (Pemasukan, Pengeluaran)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        _buildSummaryCard(
                          title: 'Pemasukan',
                          amount: formatRupiah(summary.totalIncome),
                          subtitle: 'Total Masuk',
                          isIncome: true,
                          backgroundColor: const Color(
                            0xFFE2FBEA,
                          ), // Light mint green
                          iconColor: AppColors.incomeGreen,
                        ),
                        const SizedBox(width: 12),
                        _buildSummaryCard(
                          title: 'Pengeluaran',
                          amount: formatRupiah(summary.totalExpense),
                          subtitle: 'Total Keluar',
                          isIncome: false,
                          backgroundColor: const Color(
                            0xFFFDF0DF,
                          ), // White-ish/Light peach
                          iconColor: AppColors.expenseRed,
                        ),
                      ],
                    ),
                  ),
                ),

                // Search & Filter
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackgroundPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Cari transaksi...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter Buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTimeRangeChip(),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                'Jenis',
                                Icons.swap_vert,
                                activeValue: typeFilter,
                                onTap: _showTypeFilter,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                'Kategori',
                                Icons.filter_alt,
                                activeValue: categoryFilter,
                                onTap: _showCategoryFilter,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip(
                                'Pembayaran',
                                Icons.credit_card,
                                activeValue: paymentFilter,
                                onTap: _showPaymentFilter,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Transaction List Grouped by Date
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final groupKey = groupedData.keys.elementAt(index);
                    final items = groupedData[groupKey]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupKey,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...items.map(_buildTransactionItem),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  }, childCount: groupedData.keys.length),
                ),

                // Load More Button
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBgPurple,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Muat Lebih Banyak',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required String subtitle,
    required bool isIncome,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: iconColor,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  void _showScrollableFilterSheet({
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackgroundPurple,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * 0.55;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimeRangePicker() {
    _showScrollableFilterSheet(
      title: 'Rentang Waktu',
      children: [
        _buildTimeRangeTile('Hari ini'),
        _buildTimeRangeTile('7 Hari Terakhir'),
        _buildTimeRangeTile('Pilih Bulan'),
        _buildTimeRangeTile('Pilih Tanggal'),
      ],
    );
  }

  Widget _buildTimeRangeTile(String label) {
    bool isSelected = false;
    if (label == 'Hari ini' || label == '7 Hari Terakhir') {
      isSelected = timeRangeType == 'rentang_waktu' && timeRangeValue == label;
    } else if (label == 'Pilih Bulan') {
      isSelected = timeRangeType == 'bulan';
    } else if (label == 'Pilih Tanggal') {
      isSelected = timeRangeType == 'tanggal_custom';
    }

    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.textPrimary)
          : null,
      onTap: () async {
        Navigator.pop(context);

        if (label == 'Pilih Bulan') {
          _showMonthSelectionSheet();
        } else if (label == 'Pilih Tanggal') {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.textPrimary,
                    onPrimary: Colors.white,
                    onSurface: AppColors.textPrimary,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              timeRangeType = 'tanggal_custom';
              timeRangeValue = formatDateInput(picked);
            });
          }
        } else {
          setState(() {
            timeRangeType = 'rentang_waktu';
            timeRangeValue = label;
          });
        }
      },
    );
  }

  void _showMonthSelectionSheet() {
    final now = DateTime.now();
    final months = List<DateTime>.generate(24, (index) {
      final date = DateTime(now.year, now.month - index);
      return DateTime(date.year, date.month);
    });

    _showScrollableFilterSheet(
      title: 'Pilih Bulan',
      children: months.map((month) {
        final monthKey = formatMonthYearKey(month);
        final isSelected = timeRangeType == 'bulan' && timeRangeValue == monthKey;

        return ListTile(
          title: Text(
            formatMonthYear(month),
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: AppColors.textPrimary)
              : null,
          onTap: () {
            setState(() {
              selectedMonth = month;
              timeRangeType = 'bulan';
              timeRangeValue = monthKey;
            });
            Navigator.pop(context);
          },
        );
      }).toList(),
    );
  }

  void _showTypeFilter() {
    _showScrollableFilterSheet(
      title: 'Pilih Jenis Transaksi',
      children: [
        ListTile(
          title: const Text('Pemasukan (Uang Masuk)', style: TextStyle(color: AppColors.textPrimary)),
          trailing: typeFilter == 'pemasukan'
              ? const Icon(Icons.check, color: AppColors.textPrimary)
              : null,
          onTap: () {
            setState(() {
              typeFilter = 'pemasukan';
            });
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Pengeluaran (Uang Keluar)', style: TextStyle(color: AppColors.textPrimary)),
          trailing: typeFilter == 'pengeluaran'
              ? const Icon(Icons.check, color: AppColors.textPrimary)
              : null,
          onTap: () {
            setState(() {
              typeFilter = 'pengeluaran';
            });
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Semua Transaksi', style: TextStyle(color: AppColors.textSecondary)),
          onTap: () {
            setState(() {
              typeFilter = '';
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showCategoryFilter() {
    final categories = _transactionService.getAvailableCategories();

    _showScrollableFilterSheet(
      title: 'Pilih Kategori',
      children: [
        ...categories.map(
          (category) => ListTile(
            title: Text(
              category,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            trailing: categoryFilter == category
                ? const Icon(Icons.check, color: AppColors.textPrimary)
                : null,
            onTap: () {
              setState(() {
                categoryFilter = category;
              });
              Navigator.pop(context);
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Semua Kategori',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          onTap: () {
            setState(() {
              categoryFilter = '';
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void _showPaymentFilter() {
    final methods = _transactionService.getAvailablePaymentMethods();

    _showScrollableFilterSheet(
      title: 'Pilih Metode Pembayaran',
      children: [
        ...methods.map(
          (method) => ListTile(
            title: Text(
              method,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            trailing: paymentFilter == method
                ? const Icon(Icons.check, color: AppColors.textPrimary)
                : null,
            onTap: () {
              setState(() {
                paymentFilter = method;
              });
              Navigator.pop(context);
            },
          ),
        ),
        ListTile(
          title: const Text(
            'Semua Metode',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          onTap: () {
            setState(() {
              paymentFilter = '';
            });
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildTimeRangeChip() {
    final isActive = timeRangeType == 'rentang_waktu' || timeRangeType == 'bulan' || timeRangeType == 'tanggal_custom';
    String label = 'Rentang Waktu';
    if (timeRangeType == 'rentang_waktu') {
      label = timeRangeValue;
    } else if (timeRangeType == 'bulan') {
      label = formatMonthYear(selectedMonth);
    } else if (timeRangeType == 'tanggal_custom') {
      label = timeRangeValue;
    }

    return GestureDetector(
      onTap: _showTimeRangePicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isActive
              ? null
              : Border.all(color: AppColors.textSecondary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon, {
    required String activeValue,
    required VoidCallback onTap,
  }) {
    final isActive = activeValue.isNotEmpty;
    // Capitalize first letter of activeValue if it's 'pemasukan' or 'pengeluaran' for better display
    String displayLabel = isActive ? activeValue : label;
    if (isActive && (activeValue == 'pemasukan' || activeValue == 'pengeluaran')) {
      displayLabel = activeValue[0].toUpperCase() + activeValue.substring(1);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              displayLabel,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    final isIncome = tx.isIncome;
    final displayAmount = formatSignedRupiah(tx.amount);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundPurple, // light purple card background
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () => showTransactionDetails(context, tx),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: tx.iconBg, blurRadius: 4, spreadRadius: 2),
            ],
          ),
          child: Icon(tx.icon, color: tx.iconColor, size: 24),
        ),
        title: Text(
          tx.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          '${tx.category} • ${tx.timeLabel}',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Text(
          displayAmount,
          style: TextStyle(
            color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        currentIndex: 2, // 2 = Riwayat
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            ); // Kembali ke Beranda
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const BudgetSettingsScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Budget',
          ),
        ],
      ),
    );
  }
}
