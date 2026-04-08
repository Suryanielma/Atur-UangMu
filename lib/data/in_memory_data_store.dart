import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../constants/default_data.dart';
import '../models/budget_category_model.dart';
import '../models/budget_overview_model.dart';
import '../models/budget_settings_model.dart';
import '../models/dashboard_summary_model.dart';
import '../models/transaction_model.dart';

class InMemoryDataStore extends ChangeNotifier {
  InMemoryDataStore._internal() {
    _hydrateFromDefaults();
  }

  static final InMemoryDataStore instance = InMemoryDataStore._internal();

  late DashboardSummaryModel _homeSummary;
  late DashboardSummaryModel _historySummary;
  late BudgetOverviewModel _homeBudgetOverview;
  late BudgetSettingsModel _budgetSettings;
  late int _budgetSettingsTotalUsed;
  late List<BudgetCategoryModel> _budgetCategories;
  late List<TransactionModel> _recentTransactions;
  late List<TransactionModel> _historyTransactions;
  late List<double> _weeklyExpenseValues;
  late List<String> _weeklyExpenseDays;
  late List<String> _incomeCategories;
  late List<String> _expenseCategories;
  late List<String> _bankOptions;
  late List<String> _eWalletOptions;

  DashboardSummaryModel get homeSummary => _homeSummary;
  DashboardSummaryModel get historySummary => _historySummary;
  BudgetOverviewModel get homeBudgetOverview => _homeBudgetOverview;
  BudgetSettingsModel get budgetSettings => _budgetSettings;
  int get budgetSettingsTotalUsed => _budgetSettingsTotalUsed;

  UnmodifiableListView<BudgetCategoryModel> get budgetCategories =>
      UnmodifiableListView(_budgetCategories);

  UnmodifiableListView<TransactionModel> get recentTransactions =>
      UnmodifiableListView(_recentTransactions);

  UnmodifiableListView<TransactionModel> get historyTransactions =>
      UnmodifiableListView(_historyTransactions);

  UnmodifiableListView<double> get weeklyExpenseValues =>
      UnmodifiableListView(_weeklyExpenseValues);

  UnmodifiableListView<String> get weeklyExpenseDays =>
      UnmodifiableListView(_weeklyExpenseDays);

  double get weeklyExpenseMax => DefaultData.weeklyExpenseMax;

  UnmodifiableListView<String> get incomeCategories =>
      UnmodifiableListView(_incomeCategories);

  UnmodifiableListView<String> get expenseCategories =>
      UnmodifiableListView(_expenseCategories);

  UnmodifiableListView<String> get bankOptions =>
      UnmodifiableListView(_bankOptions);

  UnmodifiableListView<String> get eWalletOptions =>
      UnmodifiableListView(_eWalletOptions);

  void addTransaction(TransactionModel transaction) {
    _historyTransactions = [transaction, ..._historyTransactions];

    final updatedRecent = [transaction, ..._recentTransactions];
    if (updatedRecent.length > 5) {
      updatedRecent.removeRange(5, updatedRecent.length);
    }
    _recentTransactions = updatedRecent;

    _homeSummary = _homeSummary.withTransaction(transaction.amount);
    _historySummary = _historySummary.withTransaction(transaction.amount);

    if (!transaction.isIncome) {
      final expenseValue = transaction.amount.abs();
      _budgetSettingsTotalUsed += expenseValue;
      _homeBudgetOverview = _homeBudgetOverview.copyWith(
        usedAmount: _homeBudgetOverview.usedAmount + expenseValue,
      );
      _increaseCategoryUsage(transaction.category, expenseValue);
      _increaseHomeBudgetBreakdown(transaction.category, expenseValue);
    }

    notifyListeners();
  }

  void updateBudgetCategoryLimit({
    required int index,
    required int newLimitAmount,
  }) {
    if (index < 0 || index >= _budgetCategories.length) {
      return;
    }

    final updatedCategory = _budgetCategories[index].copyWith(
      limitAmount: newLimitAmount,
    );
    _budgetCategories[index] = updatedCategory;
    notifyListeners();
  }

  void updateMonthlyBudget(int newMonthlyBudget) {
    _budgetSettings = _budgetSettings.copyWith(monthlyBudget: newMonthlyBudget);
    notifyListeners();
  }

  void updateNotifications(bool value) {
    _budgetSettings = _budgetSettings.copyWith(notificationsEnabled: value);
    notifyListeners();
  }

  void updateAlert80(bool value) {
    _budgetSettings = _budgetSettings.copyWith(alert80Enabled: value);
    notifyListeners();
  }

  void updateAutoReset(bool value) {
    _budgetSettings = _budgetSettings.copyWith(autoResetEnabled: value);
    notifyListeners();
  }

  void addExpenseCategory(String category) {
    final trimmed = category.trim();
    if (trimmed.isEmpty) {
      return;
    }

    if (_expenseCategories.contains(trimmed)) {
      return;
    }

    _expenseCategories = [..._expenseCategories, trimmed];
    notifyListeners();
  }

  void addBankOption(String bankName) {
    final trimmed = bankName.trim();
    if (trimmed.isEmpty || _bankOptions.contains(trimmed)) {
      return;
    }

    _bankOptions = [..._bankOptions, trimmed];
    notifyListeners();
  }

  void addEWalletOption(String eWalletName) {
    final trimmed = eWalletName.trim();
    if (trimmed.isEmpty || _eWalletOptions.contains(trimmed)) {
      return;
    }

    _eWalletOptions = [..._eWalletOptions, trimmed];
    notifyListeners();
  }

  void _hydrateFromDefaults() {
    _homeSummary = const DashboardSummaryModel(
      totalBalance: DefaultData.homeTotalBalance,
      totalIncome: DefaultData.homeTotalIncome,
      totalExpense: DefaultData.homeTotalExpense,
    );

    _historySummary = const DashboardSummaryModel(
      totalBalance:
          DefaultData.historyTotalIncome - DefaultData.historyTotalExpense,
      totalIncome: DefaultData.historyTotalIncome,
      totalExpense: DefaultData.historyTotalExpense,
    );

    _homeBudgetOverview = BudgetOverviewModel(
      usedAmount: DefaultData.homeBudgetUsed,
      limitAmount: DefaultData.homeBudgetLimit,
      breakdown: DefaultData.homeBudgetBreakdown
          .map(BudgetBreakdownModel.fromSeed)
          .toList(growable: false),
    );

    _budgetSettings = const BudgetSettingsModel(
      notificationsEnabled: DefaultData.notificationsEnabled,
      alert80Enabled: DefaultData.alert80Enabled,
      autoResetEnabled: DefaultData.autoResetEnabled,
      monthlyBudget: DefaultData.budgetSettingsMonthlyLimit,
    );

    _budgetSettingsTotalUsed = DefaultData.budgetSettingsTotalUsed;

    _budgetCategories = DefaultData.budgetCategories
        .map(BudgetCategoryModel.fromSeed)
        .toList(growable: true);

    _recentTransactions = DefaultData.recentTransactions
        .map(TransactionModel.fromSeed)
        .toList(growable: true);

    _historyTransactions = DefaultData.historyTransactions
        .map(TransactionModel.fromSeed)
        .toList(growable: true);

    _weeklyExpenseValues = List<double>.from(DefaultData.weeklyExpenseValues);
    _weeklyExpenseDays = List<String>.from(DefaultData.weeklyExpenseDays);
    _incomeCategories = List<String>.from(DefaultData.incomeCategories);
    _expenseCategories = List<String>.from(DefaultData.expenseCategories);
    _bankOptions = List<String>.from(DefaultData.bankOptions);
    _eWalletOptions = List<String>.from(DefaultData.eWalletOptions);
  }

  void _increaseCategoryUsage(String category, int expenseValue) {
    final categoryIndex = _budgetCategories.indexWhere((item) {
      final name = item.name.toLowerCase();
      final source = category.toLowerCase();
      return source.contains(name) || name.contains(source);
    });

    if (categoryIndex == -1) {
      return;
    }

    final existing = _budgetCategories[categoryIndex];
    _budgetCategories[categoryIndex] = existing.copyWith(
      usedAmount: existing.usedAmount + expenseValue,
    );
  }

  void _increaseHomeBudgetBreakdown(String category, int expenseValue) {
    final source = category.toLowerCase();

    final updatedBreakdown = _homeBudgetOverview.breakdown
        .map((item) {
          final name = item.name.toLowerCase();
          if (!source.contains(name) && !name.contains(source)) {
            return item;
          }

          return item.copyWith(amount: item.amount + expenseValue);
        })
        .toList(growable: false);

    _homeBudgetOverview = _homeBudgetOverview.copyWith(
      breakdown: updatedBreakdown,
    );
  }
}
