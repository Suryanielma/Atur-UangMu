import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../services/budget_service.dart';
import '../services/transaction_service.dart';
import '../services/dashboard_service.dart';
import '../theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  List<String> _getBudgetWarnings() {
    final budgetService = BudgetService.instance;
    final settings = budgetService.getBudgetSettings();
    List<String> warnings = [];

    if (!settings.notificationsEnabled) return warnings;

    final globalBudget = settings.monthlyBudget;
    final globalUsed = budgetService.getBudgetSettingsTotalUsed();

    // 1. Cek peringatan budget bulanan (Global)
    if (globalBudget > 0) {
      final ratio = globalUsed / globalBudget;
      if (ratio >= 1.0) {
        warnings.add('Budget bulanan Anda sudah habis!');
      } else if (settings.alert80Enabled && ratio >= 0.8) {
        warnings.add('Budget bulanan mencapai ${(ratio * 100).toInt()}%!');
      }
    }

    // 2. Cek peringatan budget per kategori
    final categories = budgetService.getBudgetCategories();
    for (var cat in categories) {
      if (cat.limitAmount > 0) {
        final ratio = cat.usedAmount / cat.limitAmount;
        if (ratio >= 1.0) {
          warnings.add('Budget kategori ${cat.name} sudah habis!');
        } else if (settings.alert80Enabled && ratio >= 0.8) {
          warnings.add('Budget kategori ${cat.name} mencapai ${(ratio * 100).toInt()}%!');
        }
      }
    }

    return warnings;
  }

// ... import lainnya ...

int _getTodayExpenseCount() {
    final now = DateTime.now();
    
    // 1. Ambil semua history transaksi yang tersedia
    final allTransactions = TransactionService.instance.getHistoryTransactions();
    
    // 2. Filter manual di sini dengan aman
    final todayCount = allTransactions.where((tx) {
      // Pastikan tanggal transaksi ada (tidak null)
      final date = tx.createdAt ?? DateTime.now(); 
      
      final isExpense = !tx.isIncome;
      final isToday = date.year == now.year &&
                      date.month == now.month &&
                      date.day == now.day;
                      
      return isExpense && isToday;
    }).length;
    
    return todayCount;
  }

  void _showNotification(BuildContext context, List<String> warnings, int todayExpenseCount) {
    final settings = BudgetService.instance.getBudgetSettings();
    
    // Cek jika toggle notifikasi utama dimatikan
    if (!settings.notificationsEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notifikasi dimatikan pada pengaturan budget.'),
          backgroundColor: AppColors.textSecondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List Peringatan Budget (jika ada)
            if (warnings.isNotEmpty) ...[
              ...warnings.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚠️ ', style: TextStyle(fontSize: 16)),
                    Expanded(
                      child: Text(
                        w,
                        style: const TextStyle(color: AppColors.expenseRed, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
              const Divider(color: AppColors.borderSubtle),
              const SizedBox(height: 8),
            ],
            // Info Transaksi Harian
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✅ ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    todayExpenseCount > 0
                        ? 'Berhasil mencatat $todayExpenseCount pengeluaran hari ini.'
                        : 'Belum ada pengeluaran yang dicatat hari ini.',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dibungkus AnimatedBuilder agar header (terutama lonceng) bereaksi langsung kalau ada transaksi baru
    return AnimatedBuilder(
      animation: InMemoryDataStore.instance,
      builder: (context, _) {
        final userDisplayName = DashboardService.instance.getUserDisplayName();
        final warnings = _getBudgetWarnings();
        final todayExpenseCount = _getTodayExpenseCount();
        final hasNotifications = warnings.isNotEmpty;

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
                  style: const TextStyle(
                    color: AppColors.rose,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _showNotification(context, warnings, todayExpenseCount),
              child: Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.roseBg,
                    radius: 22,
                    child: Icon(Icons.notifications_rounded, color: AppColors.rose, size: 22),
                  ),
                  // Indikator Titik Merah jika ada peringatan budget
                  if (hasNotifications)
                    Positioned(
                      top: 2,
                      right: 4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.expenseRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cardBackground, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}