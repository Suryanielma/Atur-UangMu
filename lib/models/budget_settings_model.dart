class BudgetSettingsModel {
  const BudgetSettingsModel({
    required this.notificationsEnabled,
    required this.alert80Enabled,
    required this.autoResetEnabled,
    required this.monthlyBudget,
  });

  final bool notificationsEnabled;
  final bool alert80Enabled;
  final bool autoResetEnabled;
  final int monthlyBudget;

  BudgetSettingsModel copyWith({
    bool? notificationsEnabled,
    bool? alert80Enabled,
    bool? autoResetEnabled,
    int? monthlyBudget,
  }) {
    return BudgetSettingsModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      alert80Enabled: alert80Enabled ?? this.alert80Enabled,
      autoResetEnabled: autoResetEnabled ?? this.autoResetEnabled,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }
}
