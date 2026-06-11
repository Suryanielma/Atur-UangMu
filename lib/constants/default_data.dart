//data dummy

import 'package:flutter/material.dart';

class DefaultData {
  static const String userDisplayName = 'Pengguna';
  static const String budgetWarningMessage =
      'Budget mendekati 80% dari batas bulanan Anda!';
  static const String transactionLoggedMessage =
      'Berhasil mencatat 2 pengeluaran hari ini.';

  static const int homeTotalBalance = 0;
  static const int homeTotalIncome = 0;
  static const int homeTotalExpense = 0;

  static const int historyTotalIncome = 0;
  static const int historyTotalExpense = 0;

  static const int homeBudgetUsed = 0;
  static const int homeBudgetLimit = 0;

  static const bool notificationsEnabled = true;
  static const bool alert80Enabled = true;
  static const bool autoResetEnabled = true;
  static const int budgetSettingsMonthlyLimit = 0;
  static const int budgetSettingsTotalUsed = 0;

  static const List<double> weeklyExpenseValues = [0, 0, 0, 0, 0, 0, 0];
  static const List<String> weeklyExpenseDays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];
  static const double weeklyExpenseMax = 0;

  static const List<String> incomeCategories = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Lainnya',
  ];

  static const List<String> expenseCategories = [
    'Listrik',
    'Air',
    'Pulsa',
    'Asuransi',
    'Belanja',
  ];

  static const List<String> bankOptions = [
    'BCA',
    'BRI',
    'Mandiri',
    'BNI',
    'BSI',
  ];
  static const List<String> eWalletOptions = [
    'GoPay',
    'OVO',
    'DANA',
    'ShopeePay',
  ];

  static final List<Map<String, dynamic>> homeBudgetBreakdown = [];

  static final List<Map<String, dynamic>> budgetCategories = [];

  static final List<Map<String, dynamic>> recentTransactions = [];

  static final List<Map<String, dynamic>> historyTransactions = [];
}
