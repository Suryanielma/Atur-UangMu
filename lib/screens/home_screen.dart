import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/expense_chart.dart';
import '../widgets/budget_card.dart';
import '../widgets/recent_transactions.dart';
import 'transaction_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              HomeHeader(),
              SizedBox(height: 20),
              BalanceCard(),
              SizedBox(height: 16),
              ActionButtons(),
              SizedBox(height: 16),
              ExpenseChart(),
              SizedBox(height: 16),
              BudgetCard(),
              SizedBox(height: 16),
              RecentTransactions(),
              SizedBox(height: 20),
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
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textPrimary,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) { // Index 2 is 'Riwayat'
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transaksi'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
