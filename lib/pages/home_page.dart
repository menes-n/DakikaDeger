import 'package:flutter/material.dart';
import 'package:dakikadeger/models/salary_settings.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final DataService dataService;

  const HomePage({Key? key, required this.dataService}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final salary = widget.dataService.getSalarySettings();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue.shade700,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'DakikaDeğer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 48,
                        color: Colors.white.withAlpha(100),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Zamanınız = Paranız',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (salary == null)
                    _buildSetupPrompt(context)
                  else
                    Column(
                      children: [
                        _buildEarningsCard(),
                        const SizedBox(height: 16),
                        _buildBalanceCards(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  _buildQuickStatsCard(),
                  const SizedBox(height: 16),
                  _buildNavigationGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupPrompt(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.warning_outlined, color: Colors.orange, size: 32),
            const SizedBox(height: 12),
            const Text(
              'Başlamak için Maaş Ayarlarını Tamamlayın',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  DefaultTabController.of(context).animateTo(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
                child: const Text(
                  'Maaş Ayarlarını Yapılandır',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsCard() {
    final salary = widget.dataService.getSalarySettings();
    if (salary == null) return const SizedBox.shrink();

    final totalEarning = widget.dataService.calculateTotalEarning(salary);
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Card(
      elevation: 4,
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Toplam Kazanç',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatter.format(totalEarning),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.trending_up, size: 40, color: Colors.green.shade300),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCards() {
    final balance = widget.dataService.calculateNetBalance();
    final balanceWithoutExpenses = widget.dataService
        .calculateBalanceWithoutExpenses();
    final formatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺');

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gider Çıkarılmış',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(balance),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: balance >= 0 ? Colors.green.shade700 : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            elevation: 4,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gider Çıkarılmamış',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatter.format(balanceWithoutExpenses),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsCard() {
    final salary = widget.dataService.getSalarySettings();
    final overtimeEntries = widget.dataService.getOvertimeEntries();
    final incomeExpenses = widget.dataService.getIncomeExpenses();
    final notes = widget.dataService.getNotes();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hızlı İstatistikler',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'Mesai Günü',
              overtimeEntries.length.toString(),
              Icons.calendar_today,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              'Toplam İşlem',
              incomeExpenses.length.toString(),
              Icons.attach_money,
            ),
            const SizedBox(height: 8),
            _buildStatRow('Notlar', notes.length.toString(), Icons.note),
            if (salary != null) ...[
              const SizedBox(height: 8),
              _buildStatRow(
                'Maaş Türü',
                salary.type == SalaryType.hourly ? 'Saatlik' : 'Aylık',
                Icons.paid,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Erişim',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNavButton(
              context,
              'Maaş\nAyarları',
              Icons.settings,
              Colors.blue.shade700,
              1,
            ),
            _buildNavButton(
              context,
              'Mesai\nTakvimi',
              Icons.calendar_month,
              Colors.green.shade700,
              2,
            ),
            _buildNavButton(
              context,
              'Gelir/\nGider',
              Icons.attach_money,
              Colors.orange.shade700,
              3,
            ),
            _buildNavButton(
              context,
              'Günlük\nNotlar',
              Icons.note,
              Colors.purple.shade700,
              4,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    int tabIndex,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          DefaultTabController.of(context).animateTo(tabIndex);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withAlpha(100), color.withAlpha(50)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
