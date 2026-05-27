import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/balance_card.dart';
import '../widgets/action_buttons.dart';
import '../widgets/expense_chart.dart';
import '../widgets/budget_card.dart';
import '../widgets/recent_transactions.dart';
import '../utils/no_animation_route.dart';
import 'transaction_history_screen.dart';
import 'budget_settings_screen.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetSettingsScreen()),
                ),
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
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.borderSubtle, width: 1)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.rose,
        unselectedItemColor: AppColors.textHint,
        currentIndex: 0,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, noAnimationRoute(builder: (_) => const AddTransactionScreen()));
          } else if (index == 2) {
            Navigator.push(context, noAnimationRoute(builder: (_) => const TransactionHistoryScreen()));
          } else if (index == 3) {
            Navigator.push(context, noAnimationRoute(builder: (_) => const BudgetSettingsScreen()));
          }
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