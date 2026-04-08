import 'package:flutter/material.dart';

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.timeLabel,
    required this.amount,
    required this.groupLabel,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.paymentMethod,
    required this.note,
  });

  final String id;
  final String title;
  final String category;
  final String timeLabel;
  final int amount;
  final String groupLabel;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String paymentMethod;
  final String note;

  bool get isIncome => amount > 0;

  TransactionModel copyWith({
    String? id,
    String? title,
    String? category,
    String? timeLabel,
    int? amount,
    String? groupLabel,
    IconData? icon,
    Color? iconBg,
    Color? iconColor,
    String? paymentMethod,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      timeLabel: timeLabel ?? this.timeLabel,
      amount: amount ?? this.amount,
      groupLabel: groupLabel ?? this.groupLabel,
      icon: icon ?? this.icon,
      iconBg: iconBg ?? this.iconBg,
      iconColor: iconColor ?? this.iconColor,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
    );
  }

  factory TransactionModel.fromSeed(Map<String, dynamic> seed) {
    return TransactionModel(
      id: seed['id'] as String,
      title: seed['title'] as String,
      category: seed['category'] as String,
      timeLabel: seed['timeLabel'] as String,
      amount: seed['amount'] as int,
      groupLabel: seed['groupLabel'] as String,
      icon: seed['icon'] as IconData,
      iconBg: seed['iconBg'] as Color,
      iconColor: seed['iconColor'] as Color,
      paymentMethod: seed['paymentMethod'] as String,
      note: seed['note'] as String,
    );
  }
}
