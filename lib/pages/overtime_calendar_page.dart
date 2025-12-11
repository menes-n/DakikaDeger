import 'package:flutter/material.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';
import 'package:dakikadeger/extensions/list_extensions.dart';

class OvertimeCalendarPage extends StatefulWidget {
  final DataService dataService;

  const OvertimeCalendarPage({super.key, required this.dataService});

  @override
  State<OvertimeCalendarPage> createState() => _OvertimeCalendarPageState();
}

class _OvertimeCalendarPageState extends State<OvertimeCalendarPage> {
  late DateTime _selectedMonth;
  late TextEditingController _hoursController;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _hoursController = TextEditingController();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  void _showHoursDialog(DateTime date) {
    final entries = widget.dataService.getOvertimeEntries();
    final existing = entries.firstWhereOrNull((e) => _isSameDay(e.date, date));

    _hoursController.text = existing?.hours.toString() ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('dd MMMM yyyy', 'tr_TR').format(date)),
        content: TextField(
          controller: _hoursController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Mesai saati girin',
            prefixIcon: Icon(Icons.schedule),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final hours = double.tryParse(_hoursController.text);
              if (hours == null || hours < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lütfen geçerli bir saat değeri girin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (hours == 0) {
                widget.dataService.deleteOvertimeEntry(date);
              } else {
                widget.dataService.updateOvertimeEntry(date, hours);
              }

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesai Takvimi'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMonthHeader(),
            const SizedBox(height: 20),
            _buildCalendar(),
            const SizedBox(height: 20),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat('MMMM yyyy', 'tr_TR').format(_selectedMonth).toUpperCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: const Icon(Icons.arrow_right), onPressed: _nextMonth),
      ],
    );
  }

  Widget _buildCalendar() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final entries = widget.dataService.getOvertimeEntries();

    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday % 7; // 0 = Sunday

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Günler başlığı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Pz', 'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Pa']
                  .map(
                    (day) => SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Takvim günleri
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 42, // 6 weeks
              itemBuilder: (context, index) {
                final dayNumber = index - firstWeekday + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox.shrink();
                }

                final date = DateTime(
                  _selectedMonth.year,
                  _selectedMonth.month,
                  dayNumber,
                );
                final hasEntry = entries.any((e) => _isSameDay(e.date, date));
                final entry = entries.firstWhereOrNull(
                  (e) => _isSameDay(e.date, date),
                );

                return GestureDetector(
                  onTap: () => _showHoursDialog(date),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: hasEntry
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      border: Border.all(
                        color: hasEntry
                            ? Colors.green.shade700
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayNumber.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: hasEntry
                                    ? Colors.green.shade700
                                    : Colors.grey.shade600,
                              ),
                            ),
                            if (entry != null)
                              Text(
                                '${entry.hours.toStringAsFixed(1)}h',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final entries = widget.dataService.getOvertimeEntries();
    final monthEntries = entries.where((e) {
      return e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month;
    }).toList();

    final totalHours = monthEntries.fold<double>(0, (sum, e) => sum + e.hours);
    final salary = widget.dataService.getSalarySettings();

    // Overtime calculation via DataService helper
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');
    var overtimeResult = salary != null
        ? widget.dataService.calculateOvertimeForMonth(_selectedMonth)
        : null;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bu Ay Özeti',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam Mesai Saati:'),
                Text(
                  '${totalHours.toStringAsFixed(1)} saat',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('İşaretlenen Günler:'),
                Text(
                  monthEntries.length.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (salary != null && overtimeResult != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Normal Hakediş:'),
                  Text(
                    formatter.format(overtimeResult.normalEarning),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fazla Mesai Tutarı:'),
                  Text(
                    formatter.format(overtimeResult.overtimePay),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Toplam Ödenecek:'),
                  Text(
                    formatter.format(overtimeResult.totalPay),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
