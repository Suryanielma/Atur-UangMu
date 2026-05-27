import 'package:flutter/material.dart';
import '../data/in_memory_data_store.dart';

class OptionsService {
  OptionsService._internal();

  static final OptionsService instance = OptionsService._internal();

  final InMemoryDataStore _store = InMemoryDataStore.instance;

  List<String> getIncomeCategories() {
    return _store.incomeCategories;
  }

  List<String> getExpenseCategories() {
    return _store.expenseCategories;
  }

  List<String> getBankOptions() {
    return _store.bankOptions;
  }

  List<String> getEWalletOptions() {
    return _store.eWalletOptions;
  }

  IconData getIncomeCategoryIcon(String category) {
    return _store.getIncomeCategoryIcon(category);
  }

  void addIncomeCategory(String category, {IconData icon = Icons.category_outlined}) {
    _store.addIncomeCategory(category, icon: icon);
  }

  void addExpenseCategory(String category) {
    _store.addExpenseCategory(category);
  }

  void addBankOption(String bank) {
    _store.addBankOption(bank);
  }

  void addEWalletOption(String eWallet) {
    _store.addEWalletOption(eWallet);
  }

  bool isBankOption(String value) {
    return _store.bankOptions.contains(value);
  }

  bool isEWalletOption(String value) {
    return _store.eWalletOptions.contains(value);
  }
}
