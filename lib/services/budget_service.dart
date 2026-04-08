import '../data/in_memory_data_store.dart';
import '../models/budget_category_model.dart';
import '../models/budget_overview_model.dart';
import '../models/budget_settings_model.dart';

class BudgetService {
  BudgetService._internal();

  static final BudgetService instance = BudgetService._internal();

  final InMemoryDataStore _store = InMemoryDataStore.instance;

  BudgetOverviewModel getHomeBudgetOverview() {
    return _store.homeBudgetOverview;
  }

  BudgetSettingsModel getBudgetSettings() {
    return _store.budgetSettings;
  }

  int getBudgetSettingsTotalUsed() {
    return _store.budgetSettingsTotalUsed;
  }

  List<BudgetCategoryModel> getBudgetCategories() {
    return _store.budgetCategories;
  }

  void updateMonthlyBudget(int amount) {
    if (amount <= 0) {
      return;
    }
    _store.updateMonthlyBudget(amount);
  }

  void updateCategoryLimit({required int index, required int amount}) {
    if (amount <= 0) {
      return;
    }
    _store.updateBudgetCategoryLimit(index: index, newLimitAmount: amount);
  }

  void setNotifications(bool value) {
    _store.updateNotifications(value);
  }

  void setAlert80(bool value) {
    _store.updateAlert80(value);
  }

  void setAutoReset(bool value) {
    _store.updateAutoReset(value);
  }

  bool shouldShow80PercentAlert() {
    final settings = getBudgetSettings();
    if (!settings.alert80Enabled) {
      return false;
    }

    if (settings.monthlyBudget == 0) {
      return false;
    }

    final ratio = getBudgetSettingsTotalUsed() / settings.monthlyBudget;
    return ratio >= 0.8;
  }
}
