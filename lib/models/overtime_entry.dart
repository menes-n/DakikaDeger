class OvertimeEntry {
  final DateTime date;
  final double hours;

  OvertimeEntry({required this.date, required this.hours});

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'hours': hours};
  }

  factory OvertimeEntry.fromJson(Map<String, dynamic> json) {
    return OvertimeEntry(
      date: DateTime.parse(json['date'] as String),
      hours: (json['hours'] as num).toDouble(),
    );
  }
}
