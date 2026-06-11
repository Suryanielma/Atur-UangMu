import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Future<void> showBudgetAlertDialog(
  BuildContext context, {
  required List<String> messages,
}) {
  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Text('⚠️ ', style: TextStyle(fontSize: 20)),
          Text(
            'Peringatan Budget',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messages
            .map(
              (message) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  message,
                  style: TextStyle(
                    color: message.contains('habis')
                        ? AppColors.expenseRed
                        : AppColors.warningAmber,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text(
            'Mengerti',
            style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
