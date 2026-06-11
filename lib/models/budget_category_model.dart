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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'limitAmount': limitAmount,
      'usedAmount': usedAmount,
      'progressColor': progressColor.toARGB32(),
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
    };
  }

  factory BudgetCategoryModel.fromMap(Map<dynamic, dynamic> map) {
    return BudgetCategoryModel(
      name: map['name'] as String,
      limitAmount: map['limitAmount'] as int,
      usedAmount: map['usedAmount'] as int,
      progressColor: Color(map['progressColor'] as int),
      icon: IconData(
        map['iconCodePoint'] as int,
        fontFamily: map['iconFontFamily'] as String?,
      ),
    );
  }
}
