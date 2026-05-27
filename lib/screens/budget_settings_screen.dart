import 'package:flutter/material.dart';

import '../data/in_memory_data_store.dart';
import '../models/budget_category_model.dart';
import '../models/budget_settings_model.dart';
import '../services/budget_service.dart';
import '../services/dashboard_service.dart';
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

  bool _canAddOrUpdateCategoryLimit(int limitAmount, {int ignoreIndex = -1}) {
    final settings = _budgetService.getBudgetSettings();
    final categories = _budgetService.getBudgetCategories();
    int totalAllocated = 0;
    for (int i = 0; i < categories.length; i++) {
      if (i != ignoreIndex) totalAllocated += categories[i].limitAmount;
    }
    return (totalAllocated + limitAmount) <= settings.monthlyBudget;
  }

  void _showEditCategoryDialog(int index) {
    final categories = _budgetService.getBudgetCategories();
    if (index < 0 || index >= categories.length) return;
    final category = categories[index];
    showDialog(
      context: context,
      builder: (context) => BudgetCategoryDialogWidget(
        initialCategory: category,
        onSave: (name, limit, icon) {
          if (!_canAddOrUpdateCategoryLimit(limit, ignoreIndex: index)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal: Total kategori melebihi budget bulanan!')),
            );
            return;
          }
          _budgetService.updateCategoryLimit(index: index, amount: limit, name: name, icon: icon);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => BudgetCategoryDialogWidget(
        onSave: (name, limit, icon) {
          if (!_canAddOrUpdateCategoryLimit(limit)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gagal: Total kategori melebihi budget bulanan!')),
            );
            return;
          }
          final added = _budgetService.addBudgetCategory(name: name, limitAmount: limit, icon: icon);
          if (!added) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kategori sudah ada atau tidak valid')),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showEditDialog() {
    final settings = _budgetService.getBudgetSettings();
    final controller = TextEditingController(text: settings.monthlyBudget.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Budget', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
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
              
              final summary = DashboardService.instance.getHomeSummary();
              if (budget > summary.totalIncome) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Gagal', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    content: const Text('Budget tidak boleh melebihi total pemasukan saat ini!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              _budgetService.updateMonthlyBudget(budget);
              Navigator.pop(context);
            },
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
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Pengaturan Budget', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cardUtama(settings, totalPakaiGlobal),
                const SizedBox(height: 28),
                _header('Budget per Kategori', '+ Tambah', onActionTap: _showAddCategoryDialog),
                const SizedBox(height: 14),
                _buildListKategori(categories),
                const SizedBox(height: 10),
                _header('Pengaturan', ''),
                const SizedBox(height: 14),
                _kartuPengaturan(settings),
                const SizedBox(height: 28),
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
    final Color barColor = progress >= 1.0
        ? AppColors.expenseRed
        : progress >= 0.8
            ? AppColors.warningAmber
            : AppColors.incomeGreen;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.gradientPrimary, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Budget Bulanan', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Total limit pengeluaran', style: TextStyle(color: AppColors.textHint, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: _showEditDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: const Text('Edit', style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Sisa: ${formatRupiah(remaining)}',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: remaining < 0 ? AppColors.expenseRed : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text('Total Budget: ${formatRupiah(settings.monthlyBudget)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(barColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${(progress * 100).toInt()}% terpakai', style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
              Text(formatRupiah(totalPakaiGlobal), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListKategori(List<BudgetCategoryModel> categories) {
    return Column(
      children: List.generate(categories.length, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _itemKategori(categories[index], index),
      )),
    );
  }

  Widget _itemKategori(BudgetCategoryModel category, int index) {
    final isGreen = category.remainingAmount >= 0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(color: AppColors.roseBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(category.icon, color: AppColors.rose, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(formatRupiah(category.limitAmount), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textHint),
                color: AppColors.cardElevated,
                onSelected: (value) {
                  if (value == 'edit') _showEditCategoryDialog(index);
                  else if (value == 'hapus') _budgetService.deleteBudgetCategory(index);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit', style: TextStyle(color: AppColors.textPrimary))),
                  const PopupMenuItem(value: 'hapus', child: Text('Hapus', style: TextStyle(color: AppColors.expenseRed))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Terpakai', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Text(formatRupiah(category.usedAmount), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: category.progress,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(category.progressColor),
              minHeight: 7,
            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Sisa: ${formatRupiah(category.remainingAmount)}',
              style: TextStyle(color: isGreen ? AppColors.incomeGreen : AppColors.expenseRed, fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text('${(category.progress * 100).toInt()}%', style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  Widget _kartuPengaturan(BudgetSettingsModel settings) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(children: [
        _tilePengaturan(Icons.notifications_rounded, 'Notifikasi Budget', 'Peringatan saat mendekati limit', settings.notificationsEnabled, _budgetService.setNotifications),
        Divider(height: 1, color: AppColors.borderSubtle),
        _tilePengaturan(Icons.warning_amber_rounded, 'Peringatan 80%', 'Alert saat budget mencapai 80%', settings.alert80Enabled, _budgetService.setAlert80),
        Divider(height: 1, color: AppColors.borderSubtle),
        _tilePengaturan(Icons.refresh_rounded, 'Reset Otomatis', 'Reset budget setiap awal bulan', settings.autoResetEnabled, _budgetService.setAutoReset),
      ]),
    );
  }

  Widget _tilePengaturan(IconData ikon, String t, String s, bool v, ValueChanged<bool> onc) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.roseBg, borderRadius: BorderRadius.circular(10)),
        child: Icon(ikon, color: AppColors.rose, size: 18),
      ),
      title: Text(t, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(s, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
      value: v,
      onChanged: onc,
      activeColor: AppColors.rose,
      activeTrackColor: AppColors.roseBg,
      inactiveThumbColor: AppColors.textHint,
      inactiveTrackColor: AppColors.surface,
    );
  }

  Widget _tombolSimpan() {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan Berhasil Disimpan!'), backgroundColor: AppColors.rose),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.gradientSave, begin: Alignment.centerLeft, end: Alignment.centerRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.rose.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: const Center(
          child: Text('Simpan Pengaturan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _gradientButton({required String label, required List<Color> colors, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _header(String t, String a, {VoidCallback? onActionTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        if (a.isNotEmpty)
          GestureDetector(
            onTap: onActionTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.roseBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(a, style: const TextStyle(color: AppColors.rose, fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ),
      ],
    );
  }

  Widget _bottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: AppColors.rose,
        unselectedItemColor: AppColors.textHint,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) Navigator.popUntil(context, (route) => route.isFirst);
          else if (index == 1) Navigator.pushReplacement(context, noAnimationRoute(builder: (context) => const AddTransactionScreen()));
          else if (index == 2) Navigator.pushReplacement(context, noAnimationRoute(builder: (context) => const TransactionHistoryScreen()));
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Budget'),
        ],
      ),
    );
  }
}

class BudgetCategoryDialogWidget extends StatefulWidget {
  final BudgetCategoryModel? initialCategory;
  final Function(String name, int limit, IconData icon) onSave;

  const BudgetCategoryDialogWidget({super.key, this.initialCategory, required this.onSave});

  @override
  State<BudgetCategoryDialogWidget> createState() => _BudgetCategoryDialogWidgetState();
}

class _BudgetCategoryDialogWidgetState extends State<BudgetCategoryDialogWidget> {
  late TextEditingController _nameController;
  late TextEditingController _limitController;
  late IconData _selectedIcon;

  final List<IconData> _iconOptions = [
    Icons.fastfood, Icons.shopping_bag, Icons.directions_car, Icons.home, Icons.medical_services,
    Icons.school, Icons.pets, Icons.sports_esports, Icons.movie, Icons.flight,
    Icons.weekend, Icons.computer, Icons.bolt, Icons.water_drop, Icons.smartphone,
    Icons.family_restroom, Icons.card_giftcard, Icons.category,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCategory?.name ?? '');
    _limitController = TextEditingController(text: widget.initialCategory != null ? widget.initialCategory!.limitAmount.toString() : '');
    _selectedIcon = widget.initialCategory?.icon ?? Icons.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.initialCategory == null ? 'Tambah Kategori' : 'Edit Kategori';
    return Dialog(
      backgroundColor: AppColors.cardElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              const Text('Pilih Ikon', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
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

  Widget _header(String t, String a, {VoidCallback? onActionTap}) {
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
        if (a.isNotEmpty)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              a,
              style: TextStyle(
                color: pinkAksen,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
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

class BudgetCategoryDialogWidget extends StatefulWidget {
  final BudgetCategoryModel? initialCategory;
  final Function(String name, int limit, IconData icon) onSave;

  const BudgetCategoryDialogWidget({
    super.key,
    this.initialCategory,
    required this.onSave,
  });

  @override
  State<BudgetCategoryDialogWidget> createState() => _BudgetCategoryDialogWidgetState();
}

class _BudgetCategoryDialogWidgetState extends State<BudgetCategoryDialogWidget> {
  late TextEditingController _nameController;
  late TextEditingController _limitController;
  late IconData _selectedIcon;

  final List<IconData> _iconOptions = [
    Icons.fastfood,
    Icons.shopping_bag,
    Icons.directions_car,
    Icons.home,
    Icons.medical_services,
    Icons.school,
    Icons.pets,
    Icons.sports_esports,
    Icons.movie,
    Icons.flight,
    Icons.weekend,
    Icons.computer,
    Icons.bolt,
    Icons.water_drop,
    Icons.smartphone,
    Icons.family_restroom,
    Icons.card_giftcard,
    Icons.category,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialCategory?.name ?? '');
    _limitController = TextEditingController(
      text: widget.initialCategory != null ? widget.initialCategory!.limitAmount.toString() : '',
    );
    _selectedIcon = widget.initialCategory?.icon ?? Icons.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.initialCategory == null ? 'Tambah Kategori' : 'Edit Kategori';
    final Color unguTua = const Color(0xFF402273);
    final Color pinkAksen = const Color(0xFFFE5897);

    return Dialog(
      backgroundColor: const Color(0xFFFCEEF6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: unguTua, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text('Pilih Ikon', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _iconOptions.length,
                  itemBuilder: (context, index) {
                    final icon = _iconOptions[index];
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          gradient: isSelected ? const LinearGradient(colors: AppColors.gradientPrimary) : null,
                          color: isSelected ? null : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 20),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kategori',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Limit Budget',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final name = _nameController.text.trim();
                    final limit = int.tryParse(_limitController.text) ?? 0;
                    if (name.isEmpty || limit <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan limit budget harus diisi')));
                      return;
                    }
                    widget.onSave(name, limit, _selectedIcon);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: AppColors.gradientPrimary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _styledField(TextEditingController c, String label, {String? prefix, bool isNumber = false}) {
    return TextField(
      controller: c,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.rose, width: 1.5)),
      ),
    );
  }
}