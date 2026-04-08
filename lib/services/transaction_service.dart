import 'package:flutter/material.dart';

import '../data/in_memory_data_store.dart';
import '../models/transaction_model.dart';
import '../utils/app_formatters.dart';

class TransactionService {
  TransactionService._internal();

  static final TransactionService instance = TransactionService._internal();

  final InMemoryDataStore _store = InMemoryDataStore.instance;

  List<TransactionModel> getHistoryTransactions() {
    return _store.historyTransactions;
  }

  List<TransactionModel> getRecentTransactions({int limit = 5}) {
    return _store.recentTransactions.take(limit).toList(growable: false);
  }

  List<TransactionModel> filterTransactions({
    required String searchQuery,
    required String activeFilter,
  }) {
    final normalizedQuery = searchQuery.toLowerCase().trim();
    final normalizedFilter = activeFilter.toLowerCase().trim();

    return _store.historyTransactions
        .where((tx) {
          final title = tx.title.toLowerCase();
          final category = tx.category.toLowerCase();
          final groupLabel = tx.groupLabel.toLowerCase();

          final matchesQuery =
              normalizedQuery.isEmpty ||
              title.contains(normalizedQuery) ||
              category.contains(normalizedQuery);

          final matchesFilter =
              normalizedFilter.isEmpty ||
              groupLabel == normalizedFilter ||
              category == normalizedFilter;

          return matchesQuery && matchesFilter;
        })
        .toList(growable: false);
  }

  Map<String, List<TransactionModel>> groupByLabel(
    List<TransactionModel> transactions,
  ) {
    final grouped = <String, List<TransactionModel>>{};

    for (final tx in transactions) {
      grouped.putIfAbsent(tx.groupLabel, () => []);
      grouped[tx.groupLabel]!.add(tx);
    }

    return grouped;
  }

  int parseAmount(String amountInput) {
    final digitsOnly = amountInput.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digitsOnly) ?? 0;
  }

  void addTransaction({
    required bool isIncome,
    required int amount,
    required String category,
    required String paymentMethod,
    required DateTime transactionDate,
    required String note,
  }) {
    if (amount <= 0) {
      return;
    }

    final signedAmount = isIncome ? amount : -amount;

    final transaction = TransactionModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _resolveTitle(category, isIncome),
      category: category,
      timeLabel: formatDateLabel(transactionDate),
      amount: signedAmount,
      groupLabel: _resolveGroupLabel(transactionDate),
      icon: _resolveIcon(category, isIncome),
      iconBg: isIncome ? const Color(0xFFE2F6ED) : const Color(0xFFFEE7E4),
      iconColor: isIncome ? const Color(0xFF07A16B) : const Color(0xFFE43E3C),
      paymentMethod: paymentMethod,
      note: note,
    );

    _store.addTransaction(transaction);
  }

  String _resolveTitle(String category, bool isIncome) {
    if (category.trim().isEmpty) {
      return isIncome ? 'Pemasukan Baru' : 'Pengeluaran Baru';
    }

    return category;
  }

  String _resolveGroupLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;

    if (difference <= 0) {
      return 'Hari Ini';
    }
    if (difference == 1) {
      return 'Kemarin';
    }
    return 'Minggu Ini';
  }

  IconData _resolveIcon(String category, bool isIncome) {
    final normalized = category.toLowerCase();

    if (isIncome) {
      if (normalized.contains('gaji') || normalized.contains('pekerjaan')) {
        return Icons.work;
      }
      if (normalized.contains('investasi')) {
        return Icons.show_chart;
      }
      if (normalized.contains('bonus')) {
        return Icons.card_giftcard;
      }
      return Icons.account_balance_wallet;
    }

    if (normalized.contains('makan') || normalized.contains('belanja')) {
      return Icons.shopping_basket;
    }
    if (normalized.contains('transport') || normalized.contains('bensin')) {
      return Icons.directions_car;
    }
    if (normalized.contains('hiburan') || normalized.contains('movie')) {
      return Icons.movie;
    }
    if (normalized.contains('listrik') || normalized.contains('air')) {
      return Icons.home;
    }

    return Icons.receipt_long;
  }
}
