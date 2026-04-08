import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;
  final InMemoryDataStore _store = InMemoryDataStore.instance;
  final DashboardService _dashboardService = DashboardService.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final summary = _dashboardService.getHomeSummary();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Saldo',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _isBalanceVisible
                    ? formatRupiah(summary.totalBalance)
                    : 'Rp *********',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallCard(
                      title: 'Pemasukan',
                      amount: formatRupiah(summary.totalIncome),
                      icon: Icons.arrow_downward,
                      bgColor: AppColors.incomeBg,
                      textColor: AppColors.incomeGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallCard(
                      title: 'Pengeluaran',
                      amount: formatRupiah(summary.totalExpense),
                      icon: Icons.arrow_upward,
                      bgColor: AppColors.expenseBg,
                      textColor: AppColors.expenseRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSmallCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.5),
                child: Icon(icon, color: textColor, size: 14),
              ),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(color: textColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.split(' ')[0]}\n${amount.substring(amount.indexOf(' ') + 1)}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
