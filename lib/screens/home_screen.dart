import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/expense_chart.dart';
import '../widgets/budget_card.dart';
import '../widgets/recent_transactions.dart';
import 'transaction_history_screen.dart';
import 'budget_settings_screen.dart'; // Sudah ter-import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background, // Menggunakan warna latar belakang dari tema
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HomeHeader(),
              const SizedBox(height: 20),
              const BalanceCard(),
              const SizedBox(height: 16),
              const ActionButtons(),
              const SizedBox(height: 16),
              const ExpenseChart(),
              const SizedBox(height: 16),

              // PERBAIKAN: Membungkus BudgetCard agar bisa diklik dari dashboard
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BudgetSettingsScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: const BudgetCard(),
              ),

              const SizedBox(height: 16),
              const RecentTransactions(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType
            .fixed, // Tetap menampilkan label di menu bawah
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        currentIndex: 0, // Indeks 0 menandakan kita sedang di Beranda
        onTap: (index) {
          if (index == 2) {
            // Navigasi ke Riwayat Transaksi
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TransactionHistoryScreen(),
              ),
            );
          }
          // PERBAIKAN: Navigasi ke Pengaturan Budget (Indeks 3)
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
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
          ), // Item menu Budget
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
