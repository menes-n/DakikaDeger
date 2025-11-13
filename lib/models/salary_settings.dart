class SalarySettings {
  double amount;
  SalaryType type; // hourly or monthly

  SalarySettings({required this.amount, required this.type});

  // JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type == SalaryType.hourly ? 'hourly' : 'monthly',
    };
  }

  // JSON'dan çevir
  factory SalarySettings.fromJson(Map<String, dynamic> json) {
    return SalarySettings(
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] == 'hourly' ? SalaryType.hourly : SalaryType.monthly,
    );
  }
}

enum SalaryType { hourly, monthly }
