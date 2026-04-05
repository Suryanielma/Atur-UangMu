import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Transaksi Terakhir',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Lihat Semua',
                style: TextStyle(
                  color: AppColors.expenseRed,
                  fontSize: 14,
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildTransaction(
            icon: Icons.shopping_basket,
            title: 'Belanja Supermarket',
            date: '18 Des 2024, 14:30',
            amount: '- Rp 350.000',
            isIncome: false,
          ),
          const Divider(color: Colors.white, height: 24),
          _buildTransaction(
            icon: Icons.work,
            title: 'Gaji Bulanan',
            date: '17 Des 2024, 09:00',
            amount: '+ Rp 12.500.000',
            isIncome: true,
          ),
          const Divider(color: Colors.white, height: 24),
          _buildTransaction(
            icon: Icons.directions_car,
            title: 'Bensin Motor',
            date: '16 Des 2024, 18:45',
            amount: '- Rp 50.000',
            isIncome: false,
          ),
          const Divider(color: Colors.white, height: 24),
          _buildTransaction(
            icon: Icons.fastfood,
            title: 'Makan Siang',
            date: '16 Des 2024, 12:20',
            amount: '- Rp 45.000',
            isIncome: false,
          ),
          const Divider(color: Colors.white, height: 24),
          _buildTransaction(
            icon: Icons.movie,
            title: 'Nonton Bioskop',
            date: '15 Des 2024, 19:00',
            amount: '- Rp 100.000',
            isIncome: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTransaction({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
    required bool isIncome,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: isIncome ? AppColors.incomeBg : AppColors.expenseBg,
          child: Icon(icon, color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isIncome ? AppColors.incomeGreen : AppColors.expenseRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
