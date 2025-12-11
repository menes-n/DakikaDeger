class OvertimeResult {
  final double normalEarning; // Normal hakediş (pro-rata veya tam maaş)
  final double overtimeHours; // Fazla mesai saatleri
  final double overtimePerHour; // Formüle göre saat başı fazla mesai ödemesi
  final double overtimePay; // Toplam fazla mesai ödemesi
  final double totalPay; // Toplam ödenecek (normal + fazla mesai)

  OvertimeResult({
    required this.normalEarning,
    required this.overtimeHours,
    required this.overtimePerHour,
    required this.overtimePay,
    required this.totalPay,
  });
}

/// Hesaplama fonksiyonu
/// - monthlySalary: Aylık maaş
/// - standardMonthlyHours: Standart aylık çalışma saati (ör. 180 veya 225)
/// - actualWorkedHours: O ayda gerçekleşen toplam çalışma saati
OvertimeResult calculateOvertime({
  required double monthlySalary,
  required double standardMonthlyHours,
  required double actualWorkedHours,
}) {
  if (standardMonthlyHours <= 0) {
    throw ArgumentError('standardMonthlyHours must be > 0');
  }

  // Fazla mesai saat başı ödemesi (verilen formül)
  final overtimePerHour = (monthlySalary * 15.0) / 2250.0;

  if (actualWorkedHours <= standardMonthlyHours) {
    // Standart veya altında: pro-rata ödeme (saat bazlı hakediş)
    final normalEarning =
        monthlySalary * (actualWorkedHours / standardMonthlyHours);
    final rounded = double.parse(normalEarning.toStringAsFixed(2));
    return OvertimeResult(
      normalEarning: rounded,
      overtimeHours: 0.0,
      overtimePerHour: double.parse(overtimePerHour.toStringAsFixed(2)),
      overtimePay: 0.0,
      totalPay: rounded,
    );
  } else {
    // Fazla mesai var: normal hakediş tam aylık maaş, üstüne mesai
    final overtimeHours = actualWorkedHours - standardMonthlyHours;
    final overtimePay = overtimeHours * overtimePerHour;
    final normalEarning = monthlySalary;
    final total = normalEarning + overtimePay;
    return OvertimeResult(
      normalEarning: double.parse(normalEarning.toStringAsFixed(2)),
      overtimeHours: double.parse(overtimeHours.toStringAsFixed(2)),
      overtimePerHour: double.parse(overtimePerHour.toStringAsFixed(2)),
      overtimePay: double.parse(overtimePay.toStringAsFixed(2)),
      totalPay: double.parse(total.toStringAsFixed(2)),
    );
  }
}
