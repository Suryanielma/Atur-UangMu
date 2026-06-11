import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../constants/default_data.dart';
import '../models/budget_category_model.dart';
import '../models/budget_overview_model.dart';
import '../models/budget_settings_model.dart';
import '../models/dashboard_summary_model.dart';
import '../models/transaction_model.dart';

class InMemoryDataStore extends ChangeNotifier {
  late final Box<Map> _transactionsBox;
  late final Box<Map> _categoriesBox;
  late final Box _settingsBox;

  InMemoryDataStore._internal();

  static final InMemoryDataStore instance = InMemoryDataStore._internal();

  Future<void> init() async {
    _transactionsBox = await Hive.openBox<Map>('transactions');
    _categoriesBox = await Hive.openBox<Map>('budget_categories');
    _settingsBox = await Hive.openBox('settings');

    if (_transactionsBox.isEmpty && _categoriesBox.isEmpty && _settingsBox.isEmpty) {
      _hydrateFromDefaults();
      _saveAllToHive();
    } else {
      _loadFromHive();
    }
  }

  void _saveAllToHive() {
    _transactionsBox.clear();
    for (final tx in _historyTransactions) {
      _transactionsBox.put(tx.id, tx.toMap());
    }

    _categoriesBox.clear();
    for (final cat in _budgetCategories) {
      _categoriesBox.put(cat.name, cat.toMap());
    }

    _settingsBox.put('notificationsEnabled', _budgetSettings.notificationsEnabled);
    _settingsBox.put('alert80Enabled', _budgetSettings.alert80Enabled);
    _settingsBox.put('autoResetEnabled', _budgetSettings.autoResetEnabled);
    _settingsBox.put('monthlyBudget', _budgetSettings.monthlyBudget);
    _settingsBox.put('budgetSettingsTotalUsed', _budgetSettingsTotalUsed);
    _settingsBox.put('incomeCategories', _incomeCategories);
    _settingsBox.put('expenseCategories', _expenseCategories);
    _settingsBox.put('bankOptions', _bankOptions);
    _settingsBox.put('eWalletOptions', _eWalletOptions);

    final iconsMap = <String, Map<String, dynamic>>{};
    _incomeCategoryIcons.forEach((key, icon) {
      iconsMap[key] = {
        'codePoint': icon.codePoint,
        'fontFamily': icon.fontFamily,
      };
    });
    _settingsBox.put('incomeCategoryIcons', iconsMap);
  }

  void _loadFromHive() {
    final txList = <TransactionModel>[];
    for (final key in _transactionsBox.keys) {
      final map = _transactionsBox.get(key);
      if (map != null) {
        txList.add(TransactionModel.fromMap(map));
      }
    }
    _historyTransactions = txList;
    _historyTransactions.sort((a, b) {
      final tA = a.createdAt ?? DateTime.now();
      final tB = b.createdAt ?? DateTime.now();
      return tB.compareTo(tA);
    });
    _recentTransactions = _historyTransactions.take(5).toList();

    final catList = <BudgetCategoryModel>[];
    for (final key in _categoriesBox.keys) {
      final map = _categoriesBox.get(key);
      if (map != null) {
        catList.add(BudgetCategoryModel.fromMap(map));
      }
    }
    _budgetCategories = catList;

    final bool notificationsEnabled = _settingsBox.get('notificationsEnabled', defaultValue: true);
    final bool alert80Enabled = _settingsBox.get('alert80Enabled', defaultValue: true);
    final bool autoResetEnabled = _settingsBox.get('autoResetEnabled', defaultValue: true);
    final int monthlyBudget = _settingsBox.get('monthlyBudget', defaultValue: 5000000);
    _budgetSettingsTotalUsed = _settingsBox.get('budgetSettingsTotalUsed', defaultValue: 0);

    _budgetSettings = BudgetSettingsModel(
      notificationsEnabled: notificationsEnabled,
      alert80Enabled: alert80Enabled,
      autoResetEnabled: autoResetEnabled,
      monthlyBudget: monthlyBudget,
    );

    _incomeCategories = List<String>.from(_settingsBox.get('incomeCategories', defaultValue: DefaultData.incomeCategories));
    _expenseCategories = List<String>.from(_settingsBox.get('expenseCategories', defaultValue: DefaultData.expenseCategories));
    _bankOptions = List<String>.from(_settingsBox.get('bankOptions', defaultValue: DefaultData.bankOptions));
    _eWalletOptions = List<String>.from(_settingsBox.get('eWalletOptions', defaultValue: DefaultData.eWalletOptions));

    final dynamic rawIcons = _settingsBox.get('incomeCategoryIcons');
    if (rawIcons is Map) {
      _incomeCategoryIcons.clear();
      rawIcons.forEach((key, value) {
        if (value is Map) {
          final codePoint = value['codePoint'] as int;
          final fontFamily = value['fontFamily'] as String?;
          _incomeCategoryIcons[key as String] = IconData(codePoint, fontFamily: fontFamily);
        }
      });
    }

    _recalculateDerivedData();
  }

  void _recalculateDerivedData() {
    int totalIncome = 0;
    int totalExpense = 0;

    for (final tx in _historyTransactions) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount.abs();
      }
    }

    final totalBalance = totalIncome - totalExpense;

    _homeSummary = DashboardSummaryModel(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );

    _historySummary = DashboardSummaryModel(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );

    _recalculateBudgetOverview();
    _updateWeeklyExpenses();
  }

  void _recalculateBudgetOverview() {
    _budgetSettingsTotalUsed = 0;
    final Map<String, int> categoryUsage = {};

    for (final tx in _historyTransactions) {
      if (!tx.isIncome) {
        final expense = tx.amount.abs();
        _budgetSettingsTotalUsed += expense;

        for (final cat in _budgetCategories) {
          final name = cat.name.toLowerCase();
          final source = tx.category.toLowerCase();
          if (source.contains(name) || name.contains(source)) {
            categoryUsage[cat.name] = (categoryUsage[cat.name] ?? 0) + expense;
            break;
          }
        }
      }
    }

    _budgetCategories = _budgetCategories.map((cat) {
      return cat.copyWith(usedAmount: categoryUsage[cat.name] ?? 0);
    }).toList();

    final breakdown = _budgetCategories
        .map((c) => BudgetBreakdownModel(name: c.name, amount: c.usedAmount))
        .toList();

    _homeBudgetOverview = BudgetOverviewModel(
      usedAmount: _budgetSettingsTotalUsed,
      limitAmount: _budgetSettings.monthlyBudget,
      breakdown: breakdown,
    );
  }

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

  final Map<String, IconData> _incomeCategoryIcons = {
    'Gaji': Icons.work_outline_rounded,
    'Bonus': Icons.card_giftcard_rounded,
    'Investasi': Icons.show_chart_rounded,
    'Lainnya': Icons.more_horiz_rounded,
  };

  DashboardSummaryModel get homeSummary => _homeSummary;
  DashboardSummaryModel get historySummary => _historySummary;
  BudgetOverviewModel get homeBudgetOverview {
    final breakdown = _budgetCategories
        .map((c) => BudgetBreakdownModel(name: c.name, amount: c.usedAmount))
        .toList(growable: false);
    return _homeBudgetOverview.copyWith(breakdown: breakdown);
  }
  BudgetSettingsModel get budgetSettings {
    if (_budgetSettings.monthlyBudget > _homeSummary.totalIncome) {
      return _budgetSettings.copyWith(monthlyBudget: _homeSummary.totalIncome);
    }
    return _budgetSettings;
  }
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

  double get weeklyExpenseMax {
    if (_weeklyExpenseValues.isEmpty) return 1.0;
    double maxVal = _weeklyExpenseValues.reduce((curr, next) => curr > next ? curr : next);
    return maxVal < 1.0 ? 1000.0 : maxVal;
  }

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
      
      _updateWeeklyExpenses();
    }

    // Write to Hive!
    _transactionsBox.put(transaction.id, transaction.toMap());
    for (final cat in _budgetCategories) {
      _categoriesBox.put(cat.name, cat.toMap());
    }
    _settingsBox.put('budgetSettingsTotalUsed', _budgetSettingsTotalUsed);

    notifyListeners();
  }

  void updateBudgetCategoryLimit({
    required int index,
    required int newLimitAmount,
    String? newName,
    IconData? newIcon,
  }) {
    if (index < 0 || index >= _budgetCategories.length) {
      return;
    }

    final oldCategoryName = _budgetCategories[index].name;

    final updatedCategory = _budgetCategories[index].copyWith(
      limitAmount: newLimitAmount,
      name: newName,
      icon: newIcon,
    );
    _budgetCategories[index] = updatedCategory;

    // Write to Hive!
    if (newName != null && newName != oldCategoryName) {
      _categoriesBox.delete(oldCategoryName);
    }
    _categoriesBox.put(updatedCategory.name, updatedCategory.toMap());

    notifyListeners();
  }

  void deleteBudgetCategory(int index) {
    if (index >= 0 && index < _budgetCategories.length) {
      final target = _budgetCategories.removeAt(index);
      _categoriesBox.delete(target.name);
      notifyListeners();
    }
  }

  void addBudgetCategory(BudgetCategoryModel category) {
    final trimmedName = category.name.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    final exists = _budgetCategories.any(
      (item) => item.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (exists) {
      return;
    }

    _budgetCategories = [..._budgetCategories, category];
    
    // Write to Hive!
    _categoriesBox.put(category.name, category.toMap());

    notifyListeners();
  }

  void updateMonthlyBudget(int newMonthlyBudget) {
    _budgetSettings = _budgetSettings.copyWith(monthlyBudget: newMonthlyBudget);
    _homeBudgetOverview = _homeBudgetOverview.copyWith(limitAmount: newMonthlyBudget);
    
    // Write to Hive!
    _settingsBox.put('monthlyBudget', newMonthlyBudget);

    notifyListeners();
  }

  void updateNotifications(bool value) {
    _budgetSettings = _budgetSettings.copyWith(notificationsEnabled: value);
    _settingsBox.put('notificationsEnabled', value);
    notifyListeners();
  }

  void updateAlert80(bool value) {
    _budgetSettings = _budgetSettings.copyWith(alert80Enabled: value);
    _settingsBox.put('alert80Enabled', value);
    notifyListeners();
  }

  void updateAutoReset(bool value) {
    _budgetSettings = _budgetSettings.copyWith(autoResetEnabled: value);
    _settingsBox.put('autoResetEnabled', value);
    notifyListeners();
  }

  IconData getIncomeCategoryIcon(String category) {
    return _incomeCategoryIcons[category] ?? Icons.category_outlined;
  }

  void addIncomeCategory(String category, {IconData icon = Icons.category_outlined}) {
    final trimmed = category.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _incomeCategoryIcons[trimmed] = icon;

    if (_incomeCategories.contains(trimmed)) {
      final iconsMap = <String, Map<String, dynamic>>{};
      _incomeCategoryIcons.forEach((key, val) {
        iconsMap[key] = {
          'codePoint': val.codePoint,
          'fontFamily': val.fontFamily,
        };
      });
      _settingsBox.put('incomeCategoryIcons', iconsMap);
      return;
    }

    _incomeCategories = [..._incomeCategories, trimmed];

    // Write to Hive!
    _settingsBox.put('incomeCategories', _incomeCategories);
    final iconsMap = <String, Map<String, dynamic>>{};
    _incomeCategoryIcons.forEach((key, val) {
      iconsMap[key] = {
        'codePoint': val.codePoint,
        'fontFamily': val.fontFamily,
      };
    });
    _settingsBox.put('incomeCategoryIcons', iconsMap);

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
    
    // Write to Hive!
    _settingsBox.put('expenseCategories', _expenseCategories);

    notifyListeners();
  }

  void addBankOption(String bankName) {
    final trimmed = bankName.trim();
    if (trimmed.isEmpty || _bankOptions.contains(trimmed)) {
      return;
    }

    _bankOptions = [..._bankOptions, trimmed];
    
    // Write to Hive!
    _settingsBox.put('bankOptions', _bankOptions);

    notifyListeners();
  }

  void addEWalletOption(String eWalletName) {
    final trimmed = eWalletName.trim();
    if (trimmed.isEmpty || _eWalletOptions.contains(trimmed)) {
      return;
    }

    _eWalletOptions = [..._eWalletOptions, trimmed];
    
    // Write to Hive!
    _settingsBox.put('eWalletOptions', _eWalletOptions);

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

    _incomeCategories = List<String>.from(DefaultData.incomeCategories);
    _expenseCategories = List<String>.from(DefaultData.expenseCategories);
    _bankOptions = List<String>.from(DefaultData.bankOptions);
    _eWalletOptions = List<String>.from(DefaultData.eWalletOptions);

    _updateWeeklyExpenses();
  }

  void _updateWeeklyExpenses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Create an array of 7 days backward
    final List<double> values = List.filled(7, 0.0);
    final List<String> days = List.filled(7, '');
    
    final dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    for (int i = 0; i < 7; i++) {
        final d = today.subtract(Duration(days: 6 - i));
        days[i] = dayNames[d.weekday % 7];
    }

    for (final tx in _historyTransactions) {
      if (tx.isIncome) continue;
      
      DateTime rxDate;
      if (tx.createdAt != null) {
        rxDate = tx.createdAt!;
      } else {
        // Fallback for mocked data based on groupLabel
        if (tx.groupLabel == 'Hari Ini') {
          rxDate = today;
        } else if (tx.groupLabel == 'Kemarin') {
          rxDate = today.subtract(const Duration(days: 1));
        } else if (tx.groupLabel == 'Minggu Ini') {
          // just mock it as 2 days ago to show some distribution
          rxDate = today.subtract(const Duration(days: 2));
        } else {
          continue; // outside 7 days for mocked data
        }
      }

      final dateOnly = DateTime(rxDate.year, rxDate.month, rxDate.day);
      final difference = today.difference(dateOnly).inDays;
      
      if (difference >= 0 && difference < 7) {
        // map backward difference into forward index [0..6]
        final index = 6 - difference;
        values[index] += tx.amount.abs().toDouble(); // accumulation
      }
    }

    _weeklyExpenseValues = values;
    _weeklyExpenseDays = days;
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
}


