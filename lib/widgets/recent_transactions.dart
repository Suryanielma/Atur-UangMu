import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final store = InMemoryDataStore.instance;
    final transactionService = TransactionService.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final transactions = transactionService.getRecentTransactions(limit: 5);
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                    style: TextStyle(color: AppColors.expenseRed, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(transactions.length, (index) {
                final tx = transactions[index];
                final isLastItem = index == transactions.length - 1;
                return Column(
                  children: [
                    _buildTransaction(tx),
                    if (!isLastItem)
                      const Divider(color: Colors.white, height: 24),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransaction(TransactionModel transaction) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: transaction.iconBg,
          child: Icon(transaction.icon, color: transaction.iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.timeLabel,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          formatSignedRupiah(transaction.amount),
          style: TextStyle(
            color: transaction.isIncome
                ? AppColors.incomeGreen
                : AppColors.expenseRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
