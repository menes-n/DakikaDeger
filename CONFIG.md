// DakikaDeğer Uygulaması - Yapılandırma ve Konfigürasyon Dosyası

// Uygulama hakkında bilgi
const String APP_NAME = 'DakikaDeğer';
const String APP_VERSION = '1.0.0';
const String APP_BUILD = '1';
const String APP_DESCRIPTION = 'Zaman = Para. Mesai saatlerini takip edin ve kazançlarınızı hesaplayın.';

// Desteklenen Platformlar
// - Windows Desktop
// - Web (Chrome, Firefox, Edge, Safari)
// - Android
// - iOS
// - macOS
// - Linux

// Bağımlılıklar
// - flutter: SDK ^3.9.2
// - shared_preferences: ^2.2.2 (Veri saklama)
// - intl: ^0.20.2 (Tarih/saat biçimlendirmesi)
// - cupertino_icons: ^1.0.8 (iOS ikonları)

// Dosya Yapısı
/*
lib/
├── main.dart
│   └── Giriş noktası, TabBar navigasyon, tema ayarları
│
├── models/
│   ├── salary_settings.dart
│   │   └── SalarySettings class (amount, type: hourly/monthly)
│   ├── overtime_entry.dart
│   │   └── OvertimeEntry class (date, hours)
│   ├── income_expense.dart
│   │   └── IncomeExpense class (date, description, amount, isIncome)
│   └── note.dart
│       └── Note class (date, content, createdAt)
│
├── services/
│   └── data_service.dart
│       ├── Init SharedPreferences
│       ├── CRUD işlemleri (Create, Read, Update, Delete)
│       ├── Hesaplama metotları (earnings, balance)
│       └── JSON serileştirme
│
├── pages/
│   ├── home_page.dart
│   │   ├── Özet dashboard
│   │   ├── Bakiye gösterimi
│   │   ├── Hızlı istatistikler
│   │   └── Navigasyon butonları
│   │
│   ├── salary_settings_page.dart
│   │   ├── Maaş türü seçimi (Radio)
│   │   ├── Maaş miktarı giriş
│   │   ├── Kaydetme işlemi
│   │   └── Güncel ayarlar gösterimi
│   │
│   ├── overtime_calendar_page.dart
│   │   ├── Aylık takvim view (GridView)
│   │   ├── Gün seçimi dialog
│   │   ├── Mesai saati giriş
│   │   ├── Ay navigasyonu
│   │   └── Aylık özet (saat, gün, kazanç)
│   │
│   ├── income_expense_page.dart
│   │   ├── Gelir/Gider seçimi (Radio)
│   │   ├── Açıklama ve miktar giriş
│   │   ├── İşlem listesi (ListView)
│   │   ├── Silme işlemi
│   │   └── Bakiye kartları (Net, Gider Çıkarılmamış)
│   │
│   └── notes_page.dart
│       ├── Not listesi (ListView)
│       ├── Tarihli notlar
│       ├── Add/Edit dialog
│       ├── Tarih seçici
│       └── Silme işlemi
│
├── utils/
│   ├── app_localizations.dart
│   │   ├── Türkçe metin tanımları
│   │   ├── Para birimi biçimlendirmesi
│   │   └── Tarih biçimlendirmesi
│   │
│   ├── app_theme.dart
│   │   ├── Light theme tanımı
│   │   ├── Color scheme
│   │   ├── Text styles
│   │   └── Component themes
│   │
│   └── constants.dart (opsiyonel)
│       └── Sabit değerler
│
└── extensions/
    └── list_extensions.dart
        └── firstWhereOrNull<T> extension
*/

// Renkler Şeması
/*
Primary Color: #1976D2 (Mavi)
Secondary Color: #26A69A (Turkuaz)
Accent Color: #FF6F00 (Turuncu)

Success: #4CAF50 (Yeşil)
Error: #F44336 (Kırmızı)
Warning: #FFC107 (Sarı)
Info: #2196F3 (Açık Mavi)

Sayfa Renkleri:
- Home: Mavi şekler
- Salary: Mavi şekler
- Calendar: Yeşil şekler
- Income/Expense: Turuncu şekler
- Notes: Mor şekler
*/

// Veri Saklama Yapısı (SharedPreferences)
/*
salary_settings: JSON string
  {
    "amount": 50.0,
    "type": "hourly"
  }

overtime_entries: JSON array
  [
    {
      "date": "2025-11-12T00:00:00.000Z",
      "hours": 2.5
    }
  ]

income_expenses: JSON array
  [
    {
      "id": "1234567890",
      "date": "2025-11-12T10:30:00.000Z",
      "description": "Kira",
      "amount": 1000.0,
      "isIncome": false
    }
  ]

notes: JSON array
  [
    {
      "id": "1234567890",
      "date": "2025-11-12T00:00:00.000Z",
      "content": "Bugün çok yoruldum ama verimli bir gün geçti.",
      "createdAt": "2025-11-12T14:30:00.000Z"
    }
  ]
*/

// Hesaplama Algoritmaları
/*
1. SAATLIK MAAŞ İÇİN:
   Günlük Kazanç = Mesai Saati × Saatlik Ücret
   Örnek: 2.5 saat × 50 TL = 125 TL

2. AYLIQ MAAŞ İÇİN:
   Günlük Kazanç = (Mesai Saati / 8) × (Aylık Maaş / 30)
   Örnek: (2.5 / 8) × (2400 / 30) = 0.3125 × 80 = 25 TL
   
3. TOPLAM KAZANÇ:
   Toplam = Σ (Tüm Günlerin Kazançları)
   
4. NET BAKIYE:
   Net = Toplam Gelir - Toplam Gider
   
5. GIDER ÇIKARIMLMAMIŞI:
   Brüt = Toplam Gelir
*/

// Widget Hiyerarşisi
/*
MyApp (MaterialApp)
 └── MyHomePage (Scaffold + DefaultTabController)
      ├── TabBar (5 sekme)
      │
      ├── TabBarView
      │   ├── HomePage
      │   ├── SalarySettingsPage
      │   ├── OvertimeCalendarPage
      │   ├── IncomeExpensePage
      │   └── NotesPage
      │
      └── BottomNavigationBar (TabBar olarak gösterilir)
*/

// Navigasyon Yapısı
/*
- TabBar navigasyonu (swipe + tıkla)
- Bottom navigation bar ile tab seçimi
- Dialog'lar (Add/Edit işlemler için)
- Date picker (not ve tarih seçimi için)
- AlertDialog (silme onayı için)
*/

// Önemli Metotlar
/*
DataService:
- init() → Future<void> → SharedPreferences başlatma
- saveSalarySettings(SalarySettings) → Future<void>
- getSalarySettings() → SalarySettings?
- saveOvertimeEntry(OvertimeEntry) → Future<void>
- updateOvertimeEntry(DateTime, double) → Future<void>
- deleteOvertimeEntry(DateTime) → Future<void>
- getOvertimeEntries() → List<OvertimeEntry>
- saveIncomeExpense(IncomeExpense) → Future<void>
- deleteIncomeExpense(String) → Future<void>
- getIncomeExpenses() → List<IncomeExpense>
- saveNote(Note) → Future<void>
- deleteNote(String) → Future<void>
- getNotes() → List<Note>
- getNoteForDate(DateTime) → Note?
- calculateDailyEarning(DateTime, SalarySettings) → double
- calculateTotalEarning(SalarySettings) → double
- calculateNetBalance() → double
- calculateBalanceWithoutExpenses() → double
*/

// Varsayılan Davranışlar
/*
1. Uygulama açılırken SharedPreferences otomatik yüklenir
2. Veri kaydedilirken JSON'a dönüştürülür
3. Veri yüklenirken JSON'dan çözülür
4. Her işlem sonrası UI setState() ile güncellenir
5. Hata durumlarında SnackBar gösterilir
6. Tarihler UTC olarak saklanır
7. Para tutarları double olarak saklanır
*/

// Platform Spesifik Durumlar
/*
Windows/macOS/Linux:
- Desktop görünüm optimize edilmiş
- Trackpad navigasyonu destekli
- Keyboard shortcuts (opsiyonel)

Web (Chrome/Firefox/Edge):
- Responsive design
- Local storage (browser storage)
- Service worker (opsiyonel)

Android/iOS:
- Material/Cupertino design
- Touch optimized
- Native storage
*/

// Güvenlik Notları
/*
✓ Tüm veriler cihazda depolanır
✓ Cloud sync yoktur
✓ Şifreleme bulunmamaktadır (isteğe bağlı eklenebilir)
✓ Yerel dosya sistemi erişimi var
✓ İnternet izni gerekmez
*/

// Performans Notları
/*
- ListView.builder() ile verimli liste renderlemesi
- GridView.builder() ile verimli takvim renderlemesi
- SingleChildScrollView() ile scroll performansı
- setState() yerine Provider/Riverpod kullanılabilir (v2.0)
- Lazy loading uygulanabilir (v2.0)
*/

// Gelecek Geliştirmeler (v2.0)
/*
- [ ] Cloud sinkronizasyonu (Firebase)
- [ ] Data export/import (PDF, CSV)
- [ ] Kullanıcı profili
- [ ] Multiple workspace desteği
- [ ] Bildirimler/Reminders
- [ ] Analytics dashboard
- [ ] Dark mode
- [ ] Biometric authentication
- [ ] Offline-first sync
- [ ] Multi-language support (EN, FR, DE)
*/
