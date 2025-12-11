class SalarySettings {
  double amount;
  SalaryType type; // hourly or monthly
  double dailyHours; // normal daily working hours (e.g., 8.0)
  double overtimeMultiplier; // e.g., 1.5 for 50% extra

  SalarySettings({
    required this.amount,
    required this.type,
    required this.dailyHours,
    required this.overtimeMultiplier,
  });

  // JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type == SalaryType.hourly ? 'hourly' : 'monthly',
      'dailyHours': dailyHours,
      'overtimeMultiplier': overtimeMultiplier,
    };
  }

  // JSON'dan çevir
  factory SalarySettings.fromJson(Map<String, dynamic> json) {
    return SalarySettings(
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'hourly' ? SalaryType.hourly : SalaryType.monthly,
      dailyHours: (json['dailyHours'] as num?)?.toDouble() ?? 8.0,
      overtimeMultiplier:
          (json['overtimeMultiplier'] as num?)?.toDouble() ?? 1.5,
    );
  }
}

enum SalaryType { hourly, monthly }
