import 'package:flutter/material.dart';
import 'package:dakikadeger/models/salary_settings.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';

class SalarySettingsPage extends StatefulWidget {
  final DataService dataService;

  const SalarySettingsPage({super.key, required this.dataService});

  @override
  State<SalarySettingsPage> createState() => _SalarySettingsPageState();
}

class _SalarySettingsPageState extends State<SalarySettingsPage> {
  late TextEditingController _amountController;
  late TextEditingController _dailyHoursController;
  late TextEditingController _overtimeMultiplierController;
  late SalaryType _selectedType;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _dailyHoursController = TextEditingController();
    _overtimeMultiplierController = TextEditingController();
    _selectedType = SalaryType.hourly;
    _loadSalarySettings();
  }

  void _loadSalarySettings() {
    final salary = widget.dataService.getSalarySettings();
    if (salary != null) {
      _amountController.text = salary.amount.toString();
      _selectedType = salary.type;
      _dailyHoursController.text = salary.dailyHours.toString();
      _overtimeMultiplierController.text = salary.overtimeMultiplier.toString();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dailyHoursController.dispose();
    _overtimeMultiplierController.dispose();
    super.dispose();
  }

  Future<void> _saveSalarySettings() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir miktar girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dailyHours = double.tryParse(_dailyHoursController.text) ?? 8.0;
    if (dailyHours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir günlük saat değeri girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    double? parsedOvertime = double.tryParse(
      _overtimeMultiplierController.text,
    );
    final computedDefaultOvertime = _selectedType == SalaryType.monthly
        ? (amount * 15.0 / 2250.0)
        : 1.5;
    final overtimeMultiplier = parsedOvertime ?? computedDefaultOvertime;
    if (overtimeMultiplier <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir fazla mesai çarpanı girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final salary = SalarySettings(
      amount: amount,
      type: _selectedType,
      dailyHours: dailyHours,
      overtimeMultiplier: overtimeMultiplier,
    );

    await widget.dataService.saveSalarySettings(salary);
    // Bu ay için hafta içi günlerini otomatik doldur
    await widget.dataService.populateWeekdaysForMonth(
      DateTime.now(),
      dailyHours,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maaş ayarları kaydedildi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maaş Ayarları'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Maaş Türü',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<SalaryType>(
                    title: const Text('Saatlik'),
                    value: SalaryType.hourly,
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? SalaryType.hourly;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<SalaryType>(
                    title: const Text('Aylık'),
                    value: SalaryType.monthly,
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value ?? SalaryType.monthly;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Maaş Miktarı',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: _selectedType == SalaryType.hourly
                    ? '50.00'
                    : '2500.00',
                prefixIcon: const Icon(Icons.currency_lira),
                suffixText: _selectedType == SalaryType.hourly
                    ? '/saat'
                    : '/ay',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Günlük Standart Çalışma Saati',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dailyHoursController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '8.0',
                prefixIcon: const Icon(Icons.schedule),
                suffixText: '/gün',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fazla Mesai Çarpanı',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _overtimeMultiplierController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: '1.5',
                prefixIcon: const Icon(Icons.multiline_chart),
                suffixText: 'x',
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final parsedAmount =
                    double.tryParse(_amountController.text) ?? 0.0;
                final computedDefault = _selectedType == SalaryType.monthly
                    ? (parsedAmount * 15.0 / 2250.0)
                    : 1.5;
                final formatter = NumberFormat.currency(
                  locale: 'tr_TR',
                  symbol: '₺',
                );
                return Text(
                  'Varsayılan: Aylık maaş * 15 / 2250 = ${formatter.format(computedDefault)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                );
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveSalarySettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                ),
                child: const Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final salary = widget.dataService.getSalarySettings();
    if (salary == null) {
      return const SizedBox.shrink();
    }

    final typeText = salary.type == SalaryType.hourly ? 'Saatlik' : 'Aylık';
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Güncel Ayarlar',
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
                const Text('Maaş Türü:'),
                Text(
                  typeText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Maaş:'),
                Text(
                  formatter.format(salary.amount),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Günlük Standart Saat:'),
                Text(
                  '${salary.dailyHours.toStringAsFixed(1)} saat',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Fazla Mesai Çarpanı:'),
                Text(
                  '${salary.overtimeMultiplier.toStringAsFixed(2)} x',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
