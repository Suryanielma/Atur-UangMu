import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/add_transaction_screen.dart';
import '../screens/budget_settings_screen.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            'Catat Transaksi',
            Icons.add,
            AppColors.buttonBg,
            AppColors.expenseRed,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTransactionScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            'Atur Budget',
            Icons.account_balance_wallet,
            AppColors.buttonBgPurple,
            AppColors.textPrimary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BudgetSettingsScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withValues(alpha: 0.2),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
