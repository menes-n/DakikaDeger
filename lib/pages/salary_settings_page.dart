import 'package:flutter/material.dart';
import 'package:dakikadeger/models/salary_settings.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';

class SalarySettingsPage extends StatefulWidget {
  final DataService dataService;

  const SalarySettingsPage({Key? key, required this.dataService})
    : super(key: key);

  @override
  State<SalarySettingsPage> createState() => _SalarySettingsPageState();
}

class _SalarySettingsPageState extends State<SalarySettingsPage> {
  late TextEditingController _amountController;
  late SalaryType _selectedType;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _selectedType = SalaryType.hourly;
    _loadSalarySettings();
  }

  void _loadSalarySettings() {
    final salary = widget.dataService.getSalarySettings();
    if (salary != null) {
      _amountController.text = salary.amount.toString();
      _selectedType = salary.type;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveSalarySettings() {
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

    final salary = SalarySettings(amount: amount, type: _selectedType);

    widget.dataService.saveSalarySettings(salary);
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
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: _selectedType == SalaryType.hourly
                    ? '/saat'
                    : '/ay',
              ),
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
          ],
        ),
      ),
    );
  }
}
