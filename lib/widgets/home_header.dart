import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  static final BudgetService _budgetService = BudgetService.instance;
  static final DashboardService _dashboardService = DashboardService.instance;

  void _showNotification(BuildContext context) {
    final settings = _budgetService.getBudgetSettings();
    if (!settings.notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notifikasi dimatikan pada pengaturan budget.'),
        ),
      );
      return;
    }

    final shouldShowWarning = _budgetService.shouldShow80PercentAlert();
    final warningMessage = _dashboardService.getBudgetWarningMessage();
    final successMessage = _dashboardService.getTransactionLoggedMessage();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shouldShowWarning)
              Text(
                '⚠️ $warningMessage',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            Text('✅ $successMessage'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userDisplayName = _dashboardService.getUserDisplayName();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, $userDisplayName!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => _showNotification(context),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.notifications, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
