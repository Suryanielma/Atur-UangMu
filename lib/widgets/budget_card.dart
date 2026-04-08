import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/budget_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final store = InMemoryDataStore.instance;
    final budgetService = BudgetService.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final overview = budgetService.getHomeBudgetOverview();
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
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.textPrimary.withValues(
                      alpha: 0.1,
                    ),
                    child: const Icon(
                      Icons.pie_chart,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Sisa Budget Bulan Ini',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${formatRupiah(overview.usedAmount)} / ${formatRupiah(overview.limitAmount)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  Text(
                    '${overview.usagePercent}%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: overview.usageRatio,
                backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.textSecondary,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: overview.breakdown
                    .map(
                      (item) => _buildCategory(
                        item.name,
                        formatCompactRupiah(item.amount),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategory(String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
