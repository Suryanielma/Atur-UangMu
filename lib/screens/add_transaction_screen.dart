import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/no_animation_route.dart';
import 'transaction_history_screen.dart';
import 'budget_settings_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true;
  String selectedCategory = 'Gaji';
  String selectedMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Catat Transaksi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 20),
            _buildAmountInput(),
            const SizedBox(height: 20),
            _buildCategorySection(),
            const SizedBox(height: 20),
            _buildPaymentMethodSection(),
            const SizedBox(height: 20),
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildNotesSection(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isIncome = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.incomeBg.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isIncome ? AppColors.incomeGreen : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_downward,
                    color: isIncome ? AppColors.incomeGreen : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pemasukan',
                    style: TextStyle(
                      color: isIncome ? AppColors.incomeGreen : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => isIncome = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: !isIncome
                    ? AppColors.expenseBg.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !isIncome ? AppColors.expenseRed : Colors.transparent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: !isIncome ? AppColors.expenseRed : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pengeluaran',
                    style: TextStyle(
                      color: !isIncome ? AppColors.expenseRed : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jumlah Uang',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          Row(
            children: [
              const Text(
                'Rp',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: AppColors.textPrimary),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundPurple,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kategori',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryItem('Gaji', Icons.work),
              _buildCategoryItem('Bonus', Icons.card_giftcard),
              _buildCategoryItem('Investasi', Icons.show_chart),
              _buildCategoryItem('Lainnya', Icons.more_horiz),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = title),
      child: Container(
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _buildPaymentItem('Cash', Icons.money, Colors.green),
          const SizedBox(height: 12),
          _buildPaymentItem(
            'Bank',
            Icons.account_balance,
            Colors.blue,
            hasArrow: true,
          ),
          const SizedBox(height: 12),
          _buildPaymentItem(
            'E-Wallet',
            Icons.account_balance_wallet,
            Colors.purple,
            hasArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(
    String title,
    IconData icon,
    Color iconColor, {
    bool hasArrow = false,
  }) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.2),
              radius: 16,
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
            if (hasArrow) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundPurple,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tanggal Transaksi',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'mm/dd/yyyy',
                      hintStyle: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.calendar_month, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Catatan Tambahan (Opsional)',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tambahkan catatan...',
                hintStyle: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardBackgroundPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Simpan Transaksi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cardBackground,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        currentIndex: 1, // Focus on "Transaksi"
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const TransactionHistoryScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              noAnimationRoute(
                builder: (context) => const BudgetSettingsScreen(),
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
