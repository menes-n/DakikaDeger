import 'package:intl/intl.dart';

class AppLocalizations {
  static const Map<String, String> _tr = {
    // Genel
    'app_name': 'DakikaDeğer',
    'save': 'Kaydet',
    'cancel': 'İptal',
    'delete': 'Sil',
    'edit': 'Düzenle',
    'add': 'Ekle',
    'back': 'Geri',

    // Ana Sayfa
    'home': 'Ana Sayfa',
    'total_earning': 'Toplam Kazanç',
    'net_balance': 'Net Bakiye',
    'balance_with_expenses': 'Gider Çıkarılmış',
    'balance_without_expenses': 'Gider Çıkarılmamış',
    'total_income': 'Toplam Gelir',
    'quick_stats': 'Hızlı İstatistikler',
    'overtime_days': 'Mesai Günü',
    'total_transactions': 'Toplam İşlem',
    'notes_count': 'Notlar',
    'salary_type': 'Maaş Türü',
    'quick_access': 'Hızlı Erişim',
    'setup_salary': 'Başlamak için Maaş Ayarlarını Tamamlayın',
    'configure_salary': 'Maaş Ayarlarını Yapılandır',

    // Maaş Ayarları
    'salary_settings': 'Maaş Ayarları',
    'salary_type_label': 'Maaş Türü',
    'hourly': 'Saatlik',
    'monthly': 'Aylık',
    'salary_amount': 'Maaş Miktarı',
    'current_settings': 'Güncel Ayarlar',
    'salary_saved': 'Maaş ayarları kaydedildi',

    // Mesai Takvimi
    'overtime_calendar': 'Mesai Takvimi',
    'month_summary': 'Bu Ay Özeti',
    'total_overtime_hours': 'Toplam Mesai Saati',
    'marked_days': 'İşaretlenen Günler',
    'estimated_earning': 'Tahmini Kazanç',
    'enter_hours': 'Mesai saati girin',
    'hours': 'saat',
    'enter_valid_hours': 'Lütfen geçerli bir saat değeri girin',

    // Gelir/Gider
    'income_expense': 'Gelir / Gider',
    'add_transaction': 'İşlem Ekle',
    'income': 'Gelir',
    'expense': 'Gider',
    'description': 'Açıklama',
    'description_hint': 'Açıklama (örn: Kira, İşletme Geliri)',
    'amount': 'Miktar',
    'transactions': 'İşlemler',
    'income_added': 'Gelir eklendi',
    'expense_added': 'Gider eklendi',
    'deleted': 'Silindi',
    'no_transactions': 'Henüz işlem eklenmedi',
    'enter_description': 'Lütfen bir açıklama girin',
    'enter_valid_amount': 'Lütfen geçerli bir miktar girin',

    // Notlar
    'notes': 'Günlük Notlar',
    'new_note': 'Yeni Not',
    'edit_note': 'Notu Düzenle',
    'date': 'Tarih',
    'note': 'Not',
    'note_hint': 'Notunuzu yazın...',
    'no_notes': 'Henüz bir not eklenmedi',
    'note_added': 'Not eklendi',
    'note_updated': 'Not güncellendi',
    'note_deleted': 'Not silindi',
    'enter_note': 'Lütfen bir not yazın',
    'confirm_delete': 'Bu notu silmek istediğinizden emin misiniz?',
    'show_more': 'Devamını görmek için dokunun',
  };

  static String get(String key) {
    return _tr[key] ?? key;
  }

  static String formatCurrency(double amount, {String locale = 'tr_TR'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: '₺');
    return formatter.format(amount);
  }

  static String formatDate(DateTime date, {String locale = 'tr_TR'}) {
    final formatter = DateFormat('dd MMMM yyyy', locale);
    return formatter.format(date);
  }

  static String formatDateShort(DateTime date, {String locale = 'tr_TR'}) {
    final formatter = DateFormat('dd.MM.yyyy', locale);
    return formatter.format(date);
  }

  static String formatTime(DateTime dateTime, {String locale = 'tr_TR'}) {
    final formatter = DateFormat('HH:mm', locale);
    return formatter.format(dateTime);
  }

  static String formatMonthYear(DateTime date, {String locale = 'tr_TR'}) {
    final formatter = DateFormat('MMMM yyyy', locale);
    return formatter.format(date).toUpperCase();
  }
}
