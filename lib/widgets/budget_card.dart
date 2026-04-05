import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

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
            children: [
              CircleAvatar(
                backgroundColor: AppColors.textPrimary.withOpacity(0.1),
                child: const Icon(Icons.pie_chart, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sisa Budget Bulan Ini',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Rp 4.250.000 / Rp 8.000.000', style: TextStyle(color: AppColors.textSecondary)),
              Text('53%', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.53,
            backgroundColor: AppColors.textSecondary.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textSecondary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategory('Makanan', 'Rp 1.2M'),
              _buildCategory('Transport', 'Rp 800K'),
              _buildCategory('Lainnya', 'Rp 2.25M'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategory(String title, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(amount, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
