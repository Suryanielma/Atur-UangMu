import 'package:flutter/material.dart';

import '../data/in_memory_data_store.dart';
import '../models/transaction_model.dart';
import 'options_service.dart';
import '../utils/app_formatters.dart' show formatDateLabel, parseMonthYearKey, formatDateInput;

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
    String? timeRangeType,
    String? timeRangeValue,
    String? typeFilter,
    String? categoryFilter,
    String? paymentFilter,
  }) {
    final normalizedQuery = searchQuery.toLowerCase().trim();

    return _store.historyTransactions
        .where((tx) {
          final title = tx.title.toLowerCase();
          final category = tx.category.toLowerCase();
          final paymentMethod = tx.paymentMethod.toLowerCase();

          final note = tx.note.toLowerCase();

          final matchesQuery =
              normalizedQuery.isEmpty ||
              title.contains(normalizedQuery) ||
              category.contains(normalizedQuery) ||
              paymentMethod.contains(normalizedQuery) ||
              note.contains(normalizedQuery);

          if (!matchesQuery) return false;

          // Time range filter
          if (timeRangeType != null && timeRangeType.isNotEmpty) {
            final txDate = tx.createdAt ?? TransactionModel.inferDateFromGroupLabel(tx.groupLabel);
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final txDay = DateTime(txDate.year, txDate.month, txDate.day);

            if (timeRangeType == 'bulan') {
              if (timeRangeValue != null && !_isInMonth(tx, timeRangeValue)) {
                return false;
              }
            } else if (timeRangeType == 'rentang_waktu') {
              if (timeRangeValue == 'Hari ini') {
                if (txDay != today) return false;
              } else if (timeRangeValue == '7 Hari Terakhir') {
                final difference = today.difference(txDay).inDays;
                if (difference < 0 || difference > 7) return false;
              }
            } else if (timeRangeType == 'tanggal_custom') {
              if (timeRangeValue != null && timeRangeValue != formatDateInput(txDate)) {
                return false;
              }
            }
          }

          // Type filter (Pemasukan / Pengeluaran)
          if (typeFilter != null && typeFilter.isNotEmpty) {
            if (typeFilter == 'pemasukan' && !tx.isIncome) return false;
            if (typeFilter == 'pengeluaran' && tx.isIncome) return false;
          }

          // Category filter
          if (categoryFilter != null && categoryFilter.isNotEmpty) {
            final normalizedCatFilter = categoryFilter.toLowerCase().trim();
            if (!category.contains(normalizedCatFilter) && !normalizedCatFilter.contains(category)) {
              return false;
            }
          }

          // Payment method filter
          if (paymentFilter != null && paymentFilter.isNotEmpty) {
            final normalizedPayFilter = paymentFilter.toLowerCase().trim();
            if (normalizedPayFilter == 'cash' && paymentMethod != 'cash') return false;
            if (normalizedPayFilter == 'bank' && !_store.bankOptions.map((e) => e.toLowerCase()).contains(paymentMethod)) return false;
            if (normalizedPayFilter == 'e-wallet' && !_store.eWalletOptions.map((e) => e.toLowerCase()).contains(paymentMethod)) return false;
            if (normalizedPayFilter != 'cash' && normalizedPayFilter != 'bank' && normalizedPayFilter != 'e-wallet') {
              if (paymentMethod != normalizedPayFilter) return false;
            }
          }

          return true;
        })
        .toList(growable: false);
  }

  List<String> getAvailableCategories() {
    final categories = <String>{};
    categories.addAll(_store.incomeCategories);
    for (final c in _store.budgetCategories) {
      categories.add(c.name);
    }
    return categories.toList()..sort();
  }

  List<String> getAvailablePaymentMethods() {
    return ['Cash', 'Bank', 'E-Wallet'];
  }

  bool _isInMonth(TransactionModel tx, String monthKey) {
    final selected = parseMonthYearKey(monthKey);
    if (selected == null) {
      return true;
    }

    final date =
        tx.createdAt ?? TransactionModel.inferDateFromGroupLabel(tx.groupLabel);
    return date.year == selected.year && date.month == selected.month;
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
      createdAt: transactionDate,
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
    if (isIncome) {
      final customIcon = OptionsService.instance.getIncomeCategoryIcon(category);
      if (customIcon != Icons.category_outlined && customIcon != Icons.category) {
        return customIcon;
      }
      final normalized = category.toLowerCase();
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

    try {
      final found = _store.budgetCategories.firstWhere((c) => c.name == category);
      return found.icon;
    } catch (_) {}

    final normalized = category.toLowerCase();
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
