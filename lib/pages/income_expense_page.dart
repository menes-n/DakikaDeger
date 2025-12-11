import 'package:flutter/material.dart';
import 'package:dakikadeger/models/income_expense.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';

class IncomeExpensePage extends StatefulWidget {
  final DataService dataService;

  const IncomeExpensePage({super.key, required this.dataService});

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  bool _isIncome = true;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addIncomeExpense() {
    final description = _descriptionController.text.trim();
    final amount = double.tryParse(_amountController.text);

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen bir açıklama girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen geçerli bir miktar girin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final item = IncomeExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      description: description,
      amount: amount,
      isIncome: _isIncome,
    );

    widget.dataService.saveIncomeExpense(item);

    _descriptionController.clear();
    _amountController.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isIncome ? 'Gelir eklendi' : 'Gider eklendi'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteItem(String id) {
    widget.dataService.deleteIncomeExpense(id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Silindi'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gelir / Gider'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputForm(),
            const SizedBox(height: 24),
            _buildSummary(),
            const SizedBox(height: 24),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İşlem Ekle',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Gelir'),
                    value: true,
                    groupValue: _isIncome,
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value ?? true;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Gider'),
                    value: false,
                    groupValue: _isIncome,
                    onChanged: (value) {
                      setState(() {
                        _isIncome = value ?? true;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'Açıklama (örn: Kira, İşletme Geliri)',
                prefixIcon: const Icon(Icons.description),
              ),
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
                hintText: 'Miktar',
                prefixIcon: const Icon(Icons.currency_lira),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addIncomeExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
                child: const Text(
                  'Ekle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final balance = widget.dataService.calculateNetBalance();
    final balanceWithoutExpenses = widget.dataService
        .calculateBalanceWithoutExpenses();
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Column(
      children: [
        Card(
          elevation: 4,
          color: Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gider Çıkarılmış',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Net Bakiye',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  formatter.format(balance),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.green.shade700 : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4,
          color: Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gider Çıkarılmamış',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Toplam Gelir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  formatter.format(balanceWithoutExpenses),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    final items = widget.dataService.getIncomeExpenses();
    final sortedItems = List<IncomeExpense>.from(items)
      ..sort((a, b) => b.date.compareTo(a.date));

    if (sortedItems.isEmpty) {
      return Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'Henüz işlem eklenmedi',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'İşlemler',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${sortedItems.length} İşlem',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          ...sortedItems.map((item) {
            final formatter = NumberFormat.currency(
              locale: 'tr_TR',
              symbol: '₺',
            );

            return ListTile(
              leading: Icon(
                item.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: item.isIncome ? Colors.green : Colors.red,
              ),
              title: Text(item.description),
              subtitle: Text(
                DateFormat('dd MMMM yyyy', 'tr_TR').format(item.date),
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatter.format(item.amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: item.isIncome ? Colors.green : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteItem(item.id),
                    tooltip: 'Sil',
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
