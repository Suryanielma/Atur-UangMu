import 'package:flutter/material.dart';

import '../data/in_memory_data_store.dart';
import '../models/budget_category_model.dart';
import '../models/budget_settings_model.dart';
import '../services/budget_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';
import '../utils/no_animation_route.dart';
import 'add_transaction_screen.dart';
import 'transaction_history_screen.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final InMemoryDataStore _store = InMemoryDataStore.instance;
  final BudgetService _budgetService = BudgetService.instance;

  final Color warnaBackground = const Color.fromARGB(255, 246, 171, 219);
  final Color warnaKartu = const Color(0xFFFCEEF6);
  final Color unguTua = const Color(0xFF402273);
  final Color pinkAksen = const Color(0xFFFE5897);
  final Color hijauSisa = const Color(0xFF34A853);
  final Color merahAlert = const Color(0xFFFF5252);

  void _showEditCategoryDialog(int index) {
    final categories = _budgetService.getBudgetCategories();
    if (index < 0 || index >= categories.length) {
      return;
    }

    final category = categories[index];
    final controller = TextEditingController(
      text: category.limitAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Budget ${category.name}',
          style: TextStyle(color: unguTua, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: 'Rp '),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newLimit =
                  int.tryParse(controller.text) ?? category.limitAmount;
              _budgetService.updateCategoryLimit(
                index: index,
                amount: newLimit,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: pinkAksen),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final settings = _budgetService.getBudgetSettings();
    final controller = TextEditingController(
      text: settings.monthlyBudget.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Edit Budget',
          style: TextStyle(color: unguTua, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: 'Rp '),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final budget =
                  int.tryParse(controller.text) ?? settings.monthlyBudget;
              _budgetService.updateMonthlyBudget(budget);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: pinkAksen),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _store,
      builder: (context, _) {
        final settings = _budgetService.getBudgetSettings();
        final totalPakaiGlobal = _budgetService.getBudgetSettingsTotalUsed();
        final categories = _budgetService.getBudgetCategories();

        return Scaffold(
          backgroundColor: warnaBackground,
          appBar: AppBar(
            title: Text(
              'Pengaturan Budget',
              style: TextStyle(color: unguTua, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: unguTua),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardUtama(settings, totalPakaiGlobal),
                const SizedBox(height: 25),
                _header('Budget per Kategori', '+ Tambah'),
                const SizedBox(height: 15),
                _buildListKategori(categories),
                const SizedBox(height: 15),
                _header('Pengaturan', ''),
                const SizedBox(height: 15),
                _kartuPengaturan(settings),
                const SizedBox(height: 30),
                _tombolSimpan(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          bottomNavigationBar: _bottomNav(),
        );
      },
    );
  }

  Widget _cardUtama(BudgetSettingsModel settings, int totalPakaiGlobal) {
    final remaining = settings.monthlyBudget - totalPakaiGlobal;
    final progress = settings.monthlyBudget == 0
        ? 0.0
        : (totalPakaiGlobal / settings.monthlyBudget).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: warnaKartu,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white54,
                    child: Icon(Icons.calendar_today, color: Color(0xFF402273)),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget Bulanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total limit pengeluaran',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _showEditDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                  elevation: 0,
                ),
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            formatRupiah(settings.monthlyBudget),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: unguTua,
            ),
          ),
          Text(
            'Sisa: ${formatRupiah(remaining)}',
            style: TextStyle(
              color: remaining < 0 ? merahAlert : Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildListKategori(List<BudgetCategoryModel> categories) {
    return Column(
      children: List.generate(categories.length, (index) {
        final category = categories[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _itemKategori(category, index),
        );
      }),
    );
  }

  Widget _itemKategori(BudgetCategoryModel category, int index) {
    final isGreen = category.remainingAmount >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warnaKartu,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(category.icon, color: const Color(0xFFFFA559)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: unguTua,
                      ),
                    ),
                    Text(
                      formatRupiah(category.limitAmount),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showEditCategoryDialog(index),
                child: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Terpakai',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                formatRupiah(category.usedAmount),
                style: TextStyle(fontWeight: FontWeight.bold, color: unguTua),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: category.progress,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation(category.progressColor),
            minHeight: 8,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sisa: ${formatRupiah(category.remainingAmount)}',
                style: TextStyle(
                  color: isGreen ? hijauSisa : merahAlert,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                '${(category.progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kartuPengaturan(BudgetSettingsModel settings) {
    return Container(
      decoration: BoxDecoration(
        color: warnaKartu,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _tilePengaturan(
            Icons.notifications,
            'Notifikasi Budget',
            'Peringatan saat mendekati limit',
            settings.notificationsEnabled,
            _budgetService.setNotifications,
          ),
          _tilePengaturan(
            Icons.warning_amber_rounded,
            'Peringatan 80%',
            'Alert saat budget mencapai 80%',
            settings.alert80Enabled,
            _budgetService.setAlert80,
          ),
          _tilePengaturan(
            Icons.refresh,
            'Reset Otomatis',
            'Reset budget setiap awal bulan',
            settings.autoResetEnabled,
            _budgetService.setAutoReset,
          ),
        ],
      ),
    );
  }

  Widget _tilePengaturan(
    IconData ikon,
    String t,
    String s,
    bool v,
    ValueChanged<bool> onc,
  ) {
    return SwitchListTile(
      secondary: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(ikon, color: const Color(0xFFFFA559)),
      ),
      title: Text(
        t,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: unguTua,
          fontSize: 14,
        ),
      ),
      subtitle: Text(s, style: const TextStyle(fontSize: 11)),
      value: v,
      onChanged: onc,
      activeThumbColor: pinkAksen,
    );
  }

  Widget _tombolSimpan() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [pinkAksen, unguTua]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan Berhasil Disimpan!')),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Simpan Pengaturan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _header(String t, String a) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          t,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: unguTua,
            fontSize: 16,
          ),
        ),
        Text(
          a,
          style: TextStyle(
            color: pinkAksen,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const AddTransactionScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const TransactionHistoryScreen(),
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
