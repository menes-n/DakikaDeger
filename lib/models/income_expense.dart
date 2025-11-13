class IncomeExpense {
  final String id;
  final DateTime date;
  final String description;
  final double amount;
  final bool isIncome; // true: gelir, false: gider

  IncomeExpense({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.isIncome,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
      'isIncome': isIncome,
    };
  }

  factory IncomeExpense.fromJson(Map<String, dynamic> json) {
    return IncomeExpense(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      isIncome: json['isIncome'] as bool,
    );
  }
}
