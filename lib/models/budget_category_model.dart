import 'package:flutter/material.dart';

class BudgetCategoryModel {
  const BudgetCategoryModel({
    required this.name,
    required this.limitAmount,
    required this.usedAmount,
    required this.progressColor,
    required this.icon,
  });

  final String name;
  final int limitAmount;
  final int usedAmount;
  final Color progressColor;
  final IconData icon;

  int get remainingAmount => limitAmount - usedAmount;

  double get progress {
    if (limitAmount == 0) {
      return 0;
    }
    return (usedAmount / limitAmount).clamp(0.0, 1.0);
  }

  BudgetCategoryModel copyWith({
    String? name,
    int? limitAmount,
    int? usedAmount,
    Color? progressColor,
    IconData? icon,
  }) {
    return BudgetCategoryModel(
      name: name ?? this.name,
      limitAmount: limitAmount ?? this.limitAmount,
      usedAmount: usedAmount ?? this.usedAmount,
      progressColor: progressColor ?? this.progressColor,
      icon: icon ?? this.icon,
    );
  }

  factory BudgetCategoryModel.fromSeed(Map<String, dynamic> seed) {
    return BudgetCategoryModel(
      name: seed['name'] as String,
      limitAmount: seed['limitAmount'] as int,
      usedAmount: seed['usedAmount'] as int,
      progressColor: seed['progressColor'] as Color,
      icon: seed['icon'] as IconData,
    );
  }
}
