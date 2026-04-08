import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Saldo', style: TextStyle(color: AppColors.textSecondary)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                child: Icon(
                  _isBalanceVisible ? Icons.visibility : Icons.visibility_off, 
                  color: AppColors.textSecondary, 
                  size: 20
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isBalanceVisible ? 'Rp 8.750.000' : 'Rp *********',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSmallCard(
                  title: 'Pemasukan',
                  amount: 'Rp 12.500.000',
                  icon: Icons.arrow_downward,
                  bgColor: AppColors.incomeBg,
                  textColor: AppColors.incomeGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallCard(
                  title: 'Pengeluaran',
                  amount: 'Rp 3.750.000',
                  icon: Icons.arrow_upward,
                  bgColor: AppColors.expenseBg,
                  textColor: AppColors.expenseRed,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white.withOpacity(0.5),
                child: Icon(icon, color: textColor, size: 14),
              ),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(color: textColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount.split(' ')[0] + '\n' + amount.substring(amount.indexOf(' ') + 1),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.2,
            ),
          )
        ],
      ),
    );
  }
}
