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
  String activeFilter = '';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final filteredTransactions = _transactionService.filterTransactions(
          searchQuery: searchQuery,
          activeFilter: activeFilter,
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
                              _buildFilterChip(
                                'Bulan Ini',
                                Icons.calendar_today,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterChip('Kategori', Icons.filter_alt),
                              const SizedBox(width: 8),
                              _buildFilterChip('Pembayaran', Icons.credit_card),
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

  Widget _buildFilterChip(String label, IconData icon) {
    bool isActive = activeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeFilter = isActive ? '' : label; // toggle filter
        });
      },
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
              label,
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
