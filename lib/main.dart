import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:dakikadeger/services/data_service.dart';
import 'package:dakikadeger/pages/home_page.dart';
import 'package:dakikadeger/pages/salary_settings_page.dart';
import 'package:dakikadeger/pages/overtime_calendar_page.dart';
import 'package:dakikadeger/pages/income_expense_page.dart';
import 'package:dakikadeger/pages/notes_page.dart';
import 'package:dakikadeger/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  final dataService = DataService();
  await dataService.init();
  runApp(MyApp(dataService: dataService));
}

class MyApp extends StatelessWidget {
  final DataService dataService;

  const MyApp({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DakikaDeğer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: DefaultTabController(
        length: 5,
        child: MyHomePage(dataService: dataService),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DataService dataService;

  const MyHomePage({super.key, required this.dataService});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(dataService: widget.dataService),
          SalarySettingsPage(dataService: widget.dataService),
          OvertimeCalendarPage(dataService: widget.dataService),
          IncomeExpensePage(dataService: widget.dataService),
          NotesPage(dataService: widget.dataService),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: const [
          Tab(icon: Icon(Icons.home), text: 'Ana Sayfa'),
          Tab(icon: Icon(Icons.settings), text: 'Maaş'),
          Tab(icon: Icon(Icons.calendar_month), text: 'Takvim'),
          Tab(icon: Icon(Icons.attach_money), text: 'Gelir/Gider'),
          Tab(icon: Icon(Icons.note), text: 'Notlar'),
        ],
        indicator: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.blue.shade700, width: 3),
          ),
        ),
      ),
    );
  }
}
