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
            color: AppColors.cardBudget,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.sand),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.sand,
                    child: const Icon(Icons.pie_chart, color: Colors.white),
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
                backgroundColor: AppColors.sandLight,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sand),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      },
    );
  }
}
