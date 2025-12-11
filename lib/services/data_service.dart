import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dakikadeger/models/salary_settings.dart';
import 'package:dakikadeger/models/overtime_entry.dart';
import 'package:dakikadeger/models/income_expense.dart';
import 'package:dakikadeger/models/note.dart';
import 'package:dakikadeger/extensions/list_extensions.dart';
import 'package:dakikadeger/utils/overtime_calculator.dart';

class DataService {
  static const String _salaryKey = 'salary_settings';
  static const String _overtimeKey = 'overtime_entries';
  static const String _incomeExpenseKey = 'income_expenses';
  static const String _notesKey = 'notes';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== Maaş İşlemleri ==========
  Future<void> saveSalarySettings(SalarySettings salary) async {
    try {
      final json = jsonEncode(salary.toJson());
      await _prefs.setString(_salaryKey, json);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  SalarySettings? getSalarySettings() {
    final json = _prefs.getString(_salaryKey);
    if (json == null) return null;
    try {
      return SalarySettings.fromJson(jsonDecode(json));
    } catch (e) {
      // corrupted data, clear and return null
      _prefs.remove(_salaryKey);
      return null;
    }
  }

  // ========== Mesai İşlemleri ==========
  Future<void> saveOvertimeEntry(OvertimeEntry entry) async {
    try {
      final entries = getOvertimeEntries();
      entries.add(entry);
      final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
      await _prefs.setString(_overtimeKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  Future<void> updateOvertimeEntry(DateTime date, double hours) async {
    try {
      final entries = getOvertimeEntries();
      final index = entries.indexWhere((e) => _isSameDay(e.date, date));

      if (index != -1) {
        entries[index] = OvertimeEntry(date: date, hours: hours);
      } else {
        entries.add(OvertimeEntry(date: date, hours: hours));
      }

      final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
      await _prefs.setString(_overtimeKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  Future<void> deleteOvertimeEntry(DateTime date) async {
    try {
      final entries = getOvertimeEntries();
      entries.removeWhere((e) => _isSameDay(e.date, date));
      final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
      await _prefs.setString(_overtimeKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  List<OvertimeEntry> getOvertimeEntries() {
    final json = _prefs.getString(_overtimeKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => OvertimeEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _prefs.remove(_overtimeKey);
      return [];
    }
  }

  // ========== Gelir/Gider İşlemleri ==========
  Future<void> saveIncomeExpense(IncomeExpense item) async {
    try {
      final items = getIncomeExpenses();
      items.add(item);
      final jsonList = jsonEncode(items.map((e) => e.toJson()).toList());
      await _prefs.setString(_incomeExpenseKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  Future<void> deleteIncomeExpense(String id) async {
    try {
      final items = getIncomeExpenses();
      items.removeWhere((e) => e.id == id);
      final jsonList = jsonEncode(items.map((e) => e.toJson()).toList());
      await _prefs.setString(_incomeExpenseKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  List<IncomeExpense> getIncomeExpenses() {
    final json = _prefs.getString(_incomeExpenseKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => IncomeExpense.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _prefs.remove(_incomeExpenseKey);
      return [];
    }
  }

  // ========== Notlar İşlemleri ==========
  Future<void> saveNote(Note note) async {
    try {
      final notes = getNotes();
      final index = notes.indexWhere((n) => n.id == note.id);

      if (index != -1) {
        notes[index] = note;
      } else {
        notes.add(note);
      }

      final jsonList = jsonEncode(notes.map((n) => n.toJson()).toList());
      await _prefs.setString(_notesKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final notes = getNotes();
      notes.removeWhere((n) => n.id == id);
      final jsonList = jsonEncode(notes.map((n) => n.toJson()).toList());
      await _prefs.setString(_notesKey, jsonList);
    } catch (e) {
      // Handle or log error if needed
    }
  }

  List<Note> getNotes() {
    final json = _prefs.getString(_notesKey);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((n) => Note.fromJson(n as Map<String, dynamic>)).toList();
    } catch (e) {
      _prefs.remove(_notesKey);
      return [];
    }
  }

  Note? getNoteForDate(DateTime date) {
    final notes = getNotes();
    try {
      return notes.firstWhere((n) => _isSameDay(n.date, date));
    } catch (e) {
      return null;
    }
  }

  // ========== Yardımcı Metotlar ==========
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Hesaplamalar
  double calculateDailyEarning(DateTime date, SalarySettings salary) {
    final entries = getOvertimeEntries();
    final entry = entries.firstWhereOrNull((e) => _isSameDay(e.date, date));

    if (entry == null) return 0;

    // Hesaplama: fazla mesai ayrı şekilde ücretlendirilecek.
    // Temel saatlik ücret:
    final baseHourly = salary.type == SalaryType.hourly
        ? salary.amount
        : (salary.amount / 30) / salary.dailyHours;

    // Fazla mesai için multiplier uygulanır
    return entry.hours * baseHourly * salary.overtimeMultiplier;
  }

  double calculateTotalEarning(SalarySettings salary) {
    final entries = getOvertimeEntries();
    double total = 0;

    for (var entry in entries) {
      final baseHourly = salary.type == SalaryType.hourly
          ? salary.amount
          : (salary.amount / 30) / salary.dailyHours;

      total += entry.hours * baseHourly * salary.overtimeMultiplier;
    }

    return total;
  }

  // Populate weekdays (Mon-Fri) within the given month with a default hours value.
  // If `hours` is 0, entries for those weekdays will be deleted.
  Future<void> populateWeekdaysForMonth(DateTime month, double hours) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final today = DateTime.now();

    // If the requested month is in the future, do nothing.
    if (firstDay.isAfter(today)) return;

    // Determine the end date: if it's the current month, end at today; otherwise end at month's last day.
    final endDate = (month.year == today.year && month.month == today.month)
        ? today
        : lastDay;

    for (var day = 1; day <= endDate.day; day++) {
      final date = DateTime(month.year, month.month, day);
      // weekday: 1 = Monday, 5 = Friday
      if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
        if (hours == 0) {
          await deleteOvertimeEntry(date);
        } else {
          await updateOvertimeEntry(date, hours);
        }
      }
    }
  }

  /// Calculate overtime result for the given month.
  /// If [standardMonthlyHours] is not provided, falls back to `salary.dailyHours * 30`.
  OvertimeResult calculateOvertimeForMonth(
    DateTime month, {
    double? standardMonthlyHours,
  }) {
    final salary = getSalarySettings();
    if (salary == null) {
      throw StateError('Salary settings not configured');
    }

    final entries = getOvertimeEntries();
    final monthEntries = entries.where(
      (e) => e.date.year == month.year && e.date.month == month.month,
    );
    final actualWorkedHours = monthEntries.fold<double>(
      0,
      (sum, e) => sum + e.hours,
    );

    final standard = standardMonthlyHours ?? (salary.dailyHours * 30);

    return calculateOvertime(
      monthlySalary: salary.amount,
      standardMonthlyHours: standard,
      actualWorkedHours: actualWorkedHours,
    );
  }

  double calculateNetBalance() {
    double income = 0;
    double expense = 0;
    final items = getIncomeExpenses();

    for (var item in items) {
      if (item.isIncome) {
        income += item.amount;
      } else {
        expense += item.amount;
      }
    }

    return income - expense;
  }

  double calculateBalanceWithoutExpenses() {
    double income = 0;
    final items = getIncomeExpenses();

    for (var item in items) {
      if (item.isIncome) {
        income += item.amount;
      }
    }

    return income;
  }
}
