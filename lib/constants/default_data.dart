import 'package:flutter/material.dart';

class DefaultData {
  static const String userDisplayName = 'Pengguna';
  static const String budgetWarningMessage =
      'Budget mendekati 80% dari batas bulanan Anda!';
  static const String transactionLoggedMessage =
      'Berhasil mencatat 2 pengeluaran hari ini.';

  static const int homeTotalBalance = 8750000;
  static const int homeTotalIncome = 12500000;
  static const int homeTotalExpense = 3750000;

  static const int historyTotalIncome = 2500000;
  static const int historyTotalExpense = 1850000;

  static const int homeBudgetUsed = 4250000;
  static const int homeBudgetLimit = 8000000;

  static const bool notificationsEnabled = true;
  static const bool alert80Enabled = true;
  static const bool autoResetEnabled = true;
  static const int budgetSettingsMonthlyLimit = 5000000;
  static const int budgetSettingsTotalUsed = 2650000;

  static const List<double> weeklyExpenseValues = [
    400,
    300,
    500,
    400,
    650,
    480,
    420,
  ];
  static const List<String> weeklyExpenseDays = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];
  static const double weeklyExpenseMax = 700;

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

  static final List<Map<String, dynamic>> homeBudgetBreakdown = [
    {'name': 'Makanan', 'amount': 1200000},
    {'name': 'Transport', 'amount': 800000},
    {'name': 'Lainnya', 'amount': 2250000},
  ];

  static final List<Map<String, dynamic>> budgetCategories = [
    {
      'name': 'Makanan',
      'limitAmount': 1000000,
      'usedAmount': 650000,
      'progressColor': const Color(0xFFFF8C42),
      'icon': Icons.fastfood,
    },
    {
      'name': 'Transport',
      'limitAmount': 500000,
      'usedAmount': 320000,
      'progressColor': const Color(0xFF2196F3),
      'icon': Icons.drive_eta,
    },
    {
      'name': 'Hiburan',
      'limitAmount': 300000,
      'usedAmount': 280000,
      'progressColor': const Color(0xFFFF5252),
      'icon': Icons.face,
    },
    {
      'name': 'Pakaian',
      'limitAmount': 400000,
      'usedAmount': 120000,
      'progressColor': const Color(0xFF4CAF50),
      'icon': Icons.checkroom,
    },
  ];

  static final List<Map<String, dynamic>> recentTransactions = [
    {
      'id': 'recent-1',
      'title': 'Belanja Supermarket',
      'category': 'Belanja',
      'timeLabel': '18 Des 2024, 14:30',
      'amount': -350000,
      'groupLabel': 'Hari Ini',
      'icon': Icons.shopping_basket,
      'iconBg': const Color(0xFFFDB6B7),
      'iconColor': const Color(0xFFE43E3C),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'recent-2',
      'title': 'Gaji Bulanan',
      'category': 'Gaji',
      'timeLabel': '17 Des 2024, 09:00',
      'amount': 12500000,
      'groupLabel': 'Hari Ini',
      'icon': Icons.work,
      'iconBg': const Color(0xFFBCF5D0),
      'iconColor': const Color(0xFF07A16B),
      'paymentMethod': 'Bank',
      'note': '',
    },
    {
      'id': 'recent-3',
      'title': 'Bensin Motor',
      'category': 'Transportasi',
      'timeLabel': '16 Des 2024, 18:45',
      'amount': -50000,
      'groupLabel': 'Kemarin',
      'icon': Icons.directions_car,
      'iconBg': const Color(0xFFFDB6B7),
      'iconColor': const Color(0xFFE43E3C),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'recent-4',
      'title': 'Makan Siang',
      'category': 'Makanan',
      'timeLabel': '16 Des 2024, 12:20',
      'amount': -45000,
      'groupLabel': 'Kemarin',
      'icon': Icons.fastfood,
      'iconBg': const Color(0xFFFDB6B7),
      'iconColor': const Color(0xFFE43E3C),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'recent-5',
      'title': 'Nonton Bioskop',
      'category': 'Hiburan',
      'timeLabel': '15 Des 2024, 19:00',
      'amount': -100000,
      'groupLabel': 'Minggu Ini',
      'icon': Icons.movie,
      'iconBg': const Color(0xFFFDB6B7),
      'iconColor': const Color(0xFFE43E3C),
      'paymentMethod': 'E-Wallet',
      'note': '',
    },
  ];

  static final List<Map<String, dynamic>> historyTransactions = [
    {
      'id': 'history-1',
      'title': 'Belanja Groceries',
      'category': 'Makanan & Minuman',
      'timeLabel': '14:30',
      'amount': -125000,
      'groupLabel': 'Hari Ini',
      'icon': Icons.shopping_cart,
      'iconBg': const Color(0xFFDFF1FF),
      'iconColor': const Color(0xFF4C87F4),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'history-2',
      'title': 'Transfer dari Ayah',
      'category': 'Uang Saku',
      'timeLabel': '10:15',
      'amount': 500000,
      'groupLabel': 'Hari Ini',
      'icon': Icons.account_balance_wallet,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': const Color(0xFF07A16B),
      'paymentMethod': 'Bank',
      'note': '',
    },
    {
      'id': 'history-3',
      'title': 'Steam Games',
      'category': 'Hiburan',
      'timeLabel': '09:45',
      'amount': -75000,
      'groupLabel': 'Hari Ini',
      'icon': Icons.gamepad,
      'iconBg': const Color(0xFFF1E4FC),
      'iconColor': const Color(0xFF8B42F2),
      'paymentMethod': 'E-Wallet',
      'note': '',
    },
    {
      'id': 'history-4',
      'title': 'Bensin Motor',
      'category': 'Transportasi',
      'timeLabel': '18:20',
      'amount': -25000,
      'groupLabel': 'Kemarin',
      'icon': Icons.directions_car,
      'iconBg': const Color(0xFFFDF0DF),
      'iconColor': const Color(0xFFF09028),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'history-5',
      'title': 'Makan Siang',
      'category': 'Makanan & Minuman',
      'timeLabel': '12:30',
      'amount': -35000,
      'groupLabel': 'Kemarin',
      'icon': Icons.restaurant,
      'iconBg': const Color(0xFFFEE7E4),
      'iconColor': const Color(0xFFE43E3C),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'history-6',
      'title': 'Gaji Freelance',
      'category': 'Pekerjaan',
      'timeLabel': '09:00',
      'amount': 750000,
      'groupLabel': 'Kemarin',
      'icon': Icons.work,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': const Color(0xFF07A16B),
      'paymentMethod': 'Bank',
      'note': '',
    },
    {
      'id': 'history-7',
      'title': 'Listrik Bulanan',
      'category': 'Tagihan',
      'timeLabel': '3 hari lalu',
      'amount': -150000,
      'groupLabel': 'Minggu Ini',
      'icon': Icons.home,
      'iconBg': const Color(0xFFDFF1FF),
      'iconColor': const Color(0xFF4C87F4),
      'paymentMethod': 'Bank',
      'note': '',
    },
    {
      'id': 'history-8',
      'title': 'Buku Kuliah',
      'category': 'Pendidikan',
      'timeLabel': '4 hari lalu',
      'amount': -85000,
      'groupLabel': 'Minggu Ini',
      'icon': Icons.book,
      'iconBg': const Color(0xFFFEF3CB),
      'iconColor': const Color(0xFFD6A200),
      'paymentMethod': 'Cash',
      'note': '',
    },
    {
      'id': 'history-9',
      'title': 'Hadiah Ulang Tahun',
      'category': 'Lainnya',
      'timeLabel': '5 hari lalu',
      'amount': 200000,
      'groupLabel': 'Minggu Ini',
      'icon': Icons.card_giftcard,
      'iconBg': const Color(0xFFE2F6ED),
      'iconColor': const Color(0xFF07A16B),
      'paymentMethod': 'Cash',
      'note': '',
    },
  ];
}
