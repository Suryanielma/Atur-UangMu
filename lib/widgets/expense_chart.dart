import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final store = InMemoryDataStore.instance;
    final dashboardService = DashboardService.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final values = dashboardService.getWeeklyExpenseValues();
        final days = dashboardService.getWeeklyExpenseDays();
        final max = dashboardService.getWeeklyExpenseMax();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Text(
                'Grafik Pengeluaran',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(values.length, (index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 25,
                          height: (values[index] / max) * 120,
                          decoration: BoxDecoration(
                            color: AppColors.expenseRed,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
