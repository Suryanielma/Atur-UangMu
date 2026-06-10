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
    this.createdAt,
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
  final DateTime? createdAt;

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
    DateTime? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TransactionModel.fromSeed(Map<String, dynamic> seed) {
    final groupLabel = seed['groupLabel'] as String;

    return TransactionModel(
      id: seed['id'] as String,
      title: seed['title'] as String,
      category: seed['category'] as String,
      timeLabel: seed['timeLabel'] as String,
      amount: seed['amount'] as int,
      groupLabel: groupLabel,
      icon: seed['icon'] as IconData,
      iconBg: seed['iconBg'] as Color,
      iconColor: seed['iconColor'] as Color,
      paymentMethod: seed['paymentMethod'] as String,
      note: seed['note'] as String,
      createdAt:
          seed['createdAt'] as DateTime? ??
          inferDateFromGroupLabel(groupLabel),
    );
  }

  static DateTime inferDateFromGroupLabel(String groupLabel) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (groupLabel) {
      case 'Hari Ini':
        return today;
      case 'Kemarin':
        return today.subtract(const Duration(days: 1));
      case 'Minggu Ini':
        return today.subtract(const Duration(days: 4));
      case 'Bulan Lalu':
        final previousMonth = DateTime(now.year, now.month - 1, 15);
        return previousMonth;
      default:
        return today;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'timeLabel': timeLabel,
      'amount': amount,
      'groupLabel': groupLabel,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconBg': iconBg.toARGB32(),
      'iconColor': iconColor.toARGB32(),
      'paymentMethod': paymentMethod,
      'note': note,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      timeLabel: map['timeLabel'] as String,
      amount: map['amount'] as int,
      groupLabel: map['groupLabel'] as String,
      icon: IconData(
        map['iconCodePoint'] as int,
        fontFamily: map['iconFontFamily'] as String?,
      ),
      iconBg: Color(map['iconBg'] as int),
      iconColor: Color(map['iconColor'] as int),
      paymentMethod: map['paymentMethod'] as String,
      note: map['note'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
    );
  }
}
