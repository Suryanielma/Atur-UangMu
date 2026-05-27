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
            color: AppColors.rose,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.roseLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Saldo',
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _isBalanceVisible ? formatRupiah(summary.totalBalance) : 'Rp *********',
                style: const TextStyle(
                  color: Colors.white,
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
                      amount: _isBalanceVisible ? formatRupiah(summary.totalIncome) : 'Rp ******',
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallCard(
                      title: 'Pengeluaran',
                      amount: _isBalanceVisible ? formatRupiah(summary.totalExpense) : 'Rp ******',
                      icon: Icons.arrow_upward,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}