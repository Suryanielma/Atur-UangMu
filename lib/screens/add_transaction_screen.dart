import 'package:flutter/material.dart';
import '../services/options_service.dart';
import '../services/transaction_service.dart';
import '../theme/app_colors.dart';
import '../utils/no_animation_route.dart';
import '../utils/app_formatters.dart';
import '../widgets/category_dialogs.dart';
import '../widgets/bank_dialog.dart';
import '../widgets/ewallet_dialog.dart';
import 'transaction_history_screen.dart';
import 'budget_settings_screen.dart';
import '../services/budget_service.dart';
import '../services/dashboard_service.dart';
import '../models/budget_category_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final OptionsService _optionsService = OptionsService.instance;
  final TransactionService _transactionService = TransactionService.instance;

  bool isIncome = true;
  String selectedCategory = '';
  String selectedMethod = 'Cash';
  DateTime? selectedDate;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final incomeCategories = _optionsService.getIncomeCategories();
    selectedCategory = incomeCategories.isNotEmpty ? incomeCategories.first : 'Lainnya';
    selectedDate = DateTime.now();
    _dateController.text = formatDateInput(selectedDate!);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 16),
          ),
        ),
        title: const Text(
          'Catat Transaksi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 20),
            _buildAmountInput(),
            const SizedBox(height: 14),
            _buildCategorySection(),
            const SizedBox(height: 14),
            _buildPaymentMethodSection(),
            const SizedBox(height: 14),
            _buildDateSection(),
            const SizedBox(height: 14),
            _buildNotesSection(),
            const SizedBox(height: 28),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _toggleTab(
            label: 'Pemasukan',
            icon: Icons.south_rounded,
            isActive: isIncome,
            activeColor: AppColors.incomeGreen,
            onTap: () => setState(() {
              isIncome = true;
              final cats = _optionsService.getIncomeCategories();
              selectedCategory = cats.isNotEmpty ? cats.first : 'Lainnya';
            }),
          )),
          Expanded(child: _toggleTab(
            label: 'Pengeluaran',
            icon: Icons.north_rounded,
            isActive: !isIncome,
            activeColor: AppColors.expenseRed,
            onTap: () => setState(() {
              isIncome = false;
              final cats = BudgetService.instance.getBudgetCategories();
              selectedCategory = cats.isNotEmpty ? cats.first.name : 'Lainnya';
            }),
          )),
        ],
      ),
    );
  }

  Widget _toggleTab({
    required String label,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cardBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [BoxShadow(color: AppColors.borderSubtle, blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeColor : AppColors.textHint, size: 16),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.textPrimary : AppColors.textHint,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
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
          Text(
            'Jumlah Uang',
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Rp',
                style: TextStyle(
                  color: AppColors.rose,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: AppColors.borderDefault,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    final List<String> categories = isIncome
        ? _optionsService.getIncomeCategories()
        : BudgetService.instance.getBudgetCategories().map((c) => c.name).toList();
    final filtered = categories.where((c) => c.toLowerCase() != 'lainnya').toList();
    final top = filtered.take(3).toList(growable: true);
    if (filtered.length >= 3) top.add('Lainnya');

    return _sectionCard(
      label: 'Kategori',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: top.map((cat) => _buildCategoryItem(cat, _resolveCategoryIcon(cat))).toList(),
      ),
    );
  }

  IconData _resolveCategoryIcon(String category) {
    if (!isIncome && category != 'Lainnya') {
      try {
        final found = BudgetService.instance.getBudgetCategories().firstWhere((c) => c.name == category);
        return found.icon;
      } catch (_) {}
    }
    final lower = category.toLowerCase();
    if (lower.contains('gaji')) return Icons.work_outline_rounded;
    if (lower.contains('bonus')) return Icons.card_giftcard_rounded;
    if (lower.contains('investasi')) return Icons.show_chart_rounded;
    if (lower.contains('lain')) return Icons.more_horiz_rounded;
    return Icons.category_outlined;
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    final isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() => selectedCategory = title);
        if (title == 'Lainnya') _showLainnyaDialog(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.rose : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.rose : AppColors.borderSubtle,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary, size: 22),
            const SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showLainnyaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CategoryDialog(
        isIncome: isIncome,
        onCategorySelected: (cat) => setState(() => selectedCategory = cat),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return _sectionCard(
      label: 'Metode Pembayaran',
      child: Column(
        children: [
          _buildPaymentItem('Cash', Icons.payments_outlined, AppColors.incomeGreen),
          const SizedBox(height: 8),
          _buildPaymentItem('Bank', Icons.account_balance_outlined, AppColors.sand,
              hasArrow: true,
              onTapOverride: () {
                setState(() => selectedMethod = 'Bank');
                _showBankDialog(context);
              }),
          const SizedBox(height: 8),
          _buildPaymentItem('E-Wallet', Icons.account_balance_wallet_outlined, AppColors.rose,
              hasArrow: true,
              onTapOverride: () {
                setState(() => selectedMethod = 'E-Wallet');
                _showEWalletDialog(context);
              }),
        ],
      ),
    );
  }

  void _showBankDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => BankDialog(onBankSelected: (bank) => setState(() => selectedMethod = bank)));
  }

  void _showEWalletDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => EWalletDialog(onEWalletSelected: (ew) => setState(() => selectedMethod = ew)));
  }

  Widget _buildPaymentItem(
    String title,
    IconData icon,
    Color iconColor, {
    bool hasArrow = false,
    VoidCallback? onTapOverride,
  }) {
    final bankOptions = _optionsService.getBankOptions();
    final eWalletOptions = _optionsService.getEWalletOptions();
    final isSelected = selectedMethod == title ||
        (title == 'Bank' && bankOptions.contains(selectedMethod)) ||
        (title == 'E-Wallet' && eWalletOptions.contains(selectedMethod));

    String displayTitle = title;
    if (title == 'Bank' && isSelected && selectedMethod != 'Bank') displayTitle = selectedMethod;
    if (title == 'E-Wallet' && isSelected && selectedMethod != 'E-Wallet') displayTitle = selectedMethod;

    return GestureDetector(
      onTap: onTapOverride ?? () => setState(() => selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.roseBg : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.roseLight : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayTitle,
                style: TextStyle(
                  color: isSelected ? AppColors.rose : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(color: AppColors.rose, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 13),
              )
            else if (hasArrow)
              const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return _sectionCard(
      label: 'Tanggal Transaksi',
      child: GestureDetector(
        onTap: _selectDate,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: AppColors.rose, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _dateController.text.isEmpty ? 'Pilih tanggal' : _dateController.text,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.rose,
            onPrimary: Colors.white,
            surface: AppColors.cardBackground,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month, picked.day, now.hour, now.minute, now.second);
        _dateController.text = formatDateInput(selectedDate!);
      });
    }
  }

  Widget _buildNotesSection() {
    return _sectionCard(
      label: 'Catatan (Opsional)',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: TextField(
          controller: _notesController,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Tambahkan catatan...',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: _saveTransaction,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              color: AppColors.rose,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(color: AppColors.rose.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
              ],
            ),
            child: const Center(
              child: Text(
                'Simpan Transaksi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Center(
              child: Text(
                'Batal',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveTransaction() {
    final amount = _transactionService.parseAmount(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Masukkan nominal transaksi terlebih dahulu.'),
          backgroundColor: AppColors.rose,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (!isIncome) {
      final summary = DashboardService.instance.getHomeSummary();
      if (amount > summary.totalBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saldo tidak mencukupi untuk pengeluaran ini.'),
          ),
        );
        return;
      }
    }

    final now = DateTime.now();
    final dateToUse = selectedDate ?? now;
    final finalDate = DateTime(dateToUse.year, dateToUse.month, dateToUse.day, now.hour, now.minute, now.second);
    _transactionService.addTransaction(
      isIncome: isIncome,
      amount: amount,
      category: selectedCategory,
      paymentMethod: selectedMethod,
      transactionDate: finalDate,
      note: _notesController.text.trim(),
    );

    if (!isIncome) {
      final settings = BudgetService.instance.getBudgetSettings();
      final totalUsed = BudgetService.instance.getBudgetSettingsTotalUsed();
      final budget = settings.monthlyBudget;
      
      BudgetCategoryModel? category;
      try {
        category = BudgetService.instance.getBudgetCategories().firstWhere((c) => c.name == selectedCategory);
      } catch (_) {}

      bool alertShown = false;

      // 1. Cek Kategori Spesifik
      if (category != null && category.limitAmount > 0) {
        final ratio = category.usedAmount / category.limitAmount;
        if (settings.notificationsEnabled && ratio >= 1.0) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Peringatan: Budget kategori ${category.name} sudah habis!'),
               backgroundColor: Colors.redAccent,
               behavior: SnackBarBehavior.floating,
               margin: EdgeInsets.only(
                 bottom: MediaQuery.sizeOf(context).height - 180,
                 left: 16,
                 right: 16,
               ),
             ),
           );
           alertShown = true;
        } else if (settings.alert80Enabled && ratio >= 0.8 && ratio < 1.0) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Peringatan: Budget kategori ${category.name} sudah mencapai 80%!'),
               backgroundColor: Colors.orange,
               behavior: SnackBarBehavior.floating,
               margin: EdgeInsets.only(
                 bottom: MediaQuery.sizeOf(context).height - 180,
                 left: 16,
                 right: 16,
               ),
             ),
           );
           alertShown = true;
        }
      }

      // 2. Cek Total Budget
      if (!alertShown && budget > 0) {
        final ratio = totalUsed / budget;
        if (settings.notificationsEnabled && ratio >= 1.0) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: const Text('Peringatan: Budget bulanan Anda sudah habis!'),
               backgroundColor: Colors.redAccent,
               behavior: SnackBarBehavior.floating,
               margin: EdgeInsets.only(
                 bottom: MediaQuery.sizeOf(context).height - 180,
                 left: 16,
                 right: 16,
               ),
             ),
           );
           alertShown = true;
        } else if (settings.alert80Enabled && ratio >= 0.8 && ratio < 1.0) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: const Text('Peringatan: Budget bulanan Anda sudah mencapai 80% dari limit!'),
               backgroundColor: Colors.orange,
               behavior: SnackBarBehavior.floating,
               margin: EdgeInsets.only(
                 bottom: MediaQuery.sizeOf(context).height - 180,
                 left: 16,
                 right: 16,
               ),
             ),
           );
           alertShown = true;
        }
      }

      if (!alertShown) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Transaksi berhasil disimpan.')),
         );
      }
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Transaksi berhasil disimpan.')),
       );
    }

    Navigator.pop(context);
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.rose,
        unselectedItemColor: AppColors.textHint,
        currentIndex: 1,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 0) Navigator.popUntil(context, (route) => route.isFirst);
          else if (index == 2) Navigator.pushReplacement(context, noAnimationRoute(builder: (_) => const TransactionHistoryScreen()));
          else if (index == 3) Navigator.pushReplacement(context, noAnimationRoute(builder: (_) => const BudgetSettingsScreen()));
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