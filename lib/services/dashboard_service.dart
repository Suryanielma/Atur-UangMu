import '../constants/default_data.dart';
import '../data/in_memory_data_store.dart';
import '../models/dashboard_summary_model.dart';

class DashboardService {
  DashboardService._internal();

  static final DashboardService instance = DashboardService._internal();

  final InMemoryDataStore _store = InMemoryDataStore.instance;

  DashboardSummaryModel getHomeSummary() {
    return _store.homeSummary;
  }

  DashboardSummaryModel getHistorySummary() {
    return _store.historySummary;
  }

  List<double> getWeeklyExpenseValues() {
    return _store.weeklyExpenseValues;
  }

  List<String> getWeeklyExpenseDays() {
    return _store.weeklyExpenseDays;
  }

  double getWeeklyExpenseMax() {
    return _store.weeklyExpenseMax;
  }

  String getUserDisplayName() {
    return DefaultData.userDisplayName;
  }

  String getBudgetWarningMessage() {
    return DefaultData.budgetWarningMessage;
  }

  String getTransactionLoggedMessage() {
    return DefaultData.transactionLoggedMessage;
  }
}
