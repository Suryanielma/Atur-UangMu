class BudgetBreakdownModel {
  const BudgetBreakdownModel({required this.name, required this.amount});

  final String name;
  final int amount;

  BudgetBreakdownModel copyWith({String? name, int? amount}) {
    return BudgetBreakdownModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }

  factory BudgetBreakdownModel.fromSeed(Map<String, dynamic> seed) {
    return BudgetBreakdownModel(
      name: seed['name'] as String,
      amount: seed['amount'] as int,
    );
  }
}

class BudgetOverviewModel {
  const BudgetOverviewModel({
    required this.usedAmount,
    required this.limitAmount,
    required this.breakdown,
  });

  final int usedAmount;
  final int limitAmount;
  final List<BudgetBreakdownModel> breakdown;

  double get usageRatio {
    if (limitAmount == 0) {
      return 0;
    }
    return (usedAmount / limitAmount).clamp(0.0, 1.0);
  }

  int get usagePercent => (usageRatio * 100).round();

  BudgetOverviewModel copyWith({
    int? usedAmount,
    int? limitAmount,
    List<BudgetBreakdownModel>? breakdown,
  }) {
    return BudgetOverviewModel(
      usedAmount: usedAmount ?? this.usedAmount,
      limitAmount: limitAmount ?? this.limitAmount,
      breakdown: breakdown ?? this.breakdown,
    );
  }
}
