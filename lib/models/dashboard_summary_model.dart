class DashboardSummaryModel {
  const DashboardSummaryModel({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  final int totalBalance;
  final int totalIncome;
  final int totalExpense;

  DashboardSummaryModel copyWith({
    int? totalBalance,
    int? totalIncome,
    int? totalExpense,
  }) {
    return DashboardSummaryModel(
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }

  DashboardSummaryModel withTransaction(int amount) {
    if (amount >= 0) {
      return copyWith(
        totalBalance: totalBalance + amount,
        totalIncome: totalIncome + amount,
      );
    }

    return copyWith(
      totalBalance: totalBalance + amount,
      totalExpense: totalExpense + amount.abs(),
    );
  }
}
