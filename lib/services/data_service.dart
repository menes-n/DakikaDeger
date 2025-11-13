import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:dakikadeger/models/salary_settings.dart';
import 'package:dakikadeger/models/overtime_entry.dart';
import 'package:dakikadeger/models/income_expense.dart';
import 'package:dakikadeger/models/note.dart';
import 'package:dakikadeger/extensions/list_extensions.dart';

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
    final json = jsonEncode(salary.toJson());
    await _prefs.setString(_salaryKey, json);
  }

  SalarySettings? getSalarySettings() {
    final json = _prefs.getString(_salaryKey);
    if (json == null) return null;
    return SalarySettings.fromJson(jsonDecode(json));
  }

  // ========== Mesai İşlemleri ==========
  Future<void> saveOvertimeEntry(OvertimeEntry entry) async {
    final entries = getOvertimeEntries();
    entries.add(entry);
    final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(_overtimeKey, jsonList);
  }

  Future<void> updateOvertimeEntry(DateTime date, double hours) async {
    final entries = getOvertimeEntries();
    final index = entries.indexWhere((e) => _isSameDay(e.date, date));

    if (index != -1) {
      entries[index] = OvertimeEntry(date: date, hours: hours);
    } else {
      entries.add(OvertimeEntry(date: date, hours: hours));
    }

    final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(_overtimeKey, jsonList);
  }

  Future<void> deleteOvertimeEntry(DateTime date) async {
    final entries = getOvertimeEntries();
    entries.removeWhere((e) => _isSameDay(e.date, date));
    final jsonList = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(_overtimeKey, jsonList);
  }

  List<OvertimeEntry> getOvertimeEntries() {
    final json = _prefs.getString(_overtimeKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => OvertimeEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ========== Gelir/Gider İşlemleri ==========
  Future<void> saveIncomeExpense(IncomeExpense item) async {
    final items = getIncomeExpenses();
    items.add(item);
    final jsonList = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_incomeExpenseKey, jsonList);
  }

  Future<void> deleteIncomeExpense(String id) async {
    final items = getIncomeExpenses();
    items.removeWhere((e) => e.id == id);
    final jsonList = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_incomeExpenseKey, jsonList);
  }

  List<IncomeExpense> getIncomeExpenses() {
    final json = _prefs.getString(_incomeExpenseKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => IncomeExpense.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ========== Notlar İşlemleri ==========
  Future<void> saveNote(Note note) async {
    final notes = getNotes();
    final index = notes.indexWhere((n) => n.id == note.id);

    if (index != -1) {
      notes[index] = note;
    } else {
      notes.add(note);
    }

    final jsonList = jsonEncode(notes.map((n) => n.toJson()).toList());
    await _prefs.setString(_notesKey, jsonList);
  }

  Future<void> deleteNote(String id) async {
    final notes = getNotes();
    notes.removeWhere((n) => n.id == id);
    final jsonList = jsonEncode(notes.map((n) => n.toJson()).toList());
    await _prefs.setString(_notesKey, jsonList);
  }

  List<Note> getNotes() {
    final json = _prefs.getString(_notesKey);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((n) => Note.fromJson(n as Map<String, dynamic>)).toList();
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

    if (salary.type == SalaryType.hourly) {
      return entry.hours * salary.amount;
    } else {
      // Aylık: gün başına 8 saat çalışıldığını varsay
      return (entry.hours / 8) * (salary.amount / 30);
    }
  }

  double calculateTotalEarning(SalarySettings salary) {
    final entries = getOvertimeEntries();
    double total = 0;

    for (var entry in entries) {
      if (salary.type == SalaryType.hourly) {
        total += entry.hours * salary.amount;
      } else {
        total += (entry.hours / 8) * (salary.amount / 30);
      }
    }

    return total;
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
