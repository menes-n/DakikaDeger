# DakikaDeğer - Zaman = Para Uygulaması

DakikaDeğer, kullanıcıların mesai saatlerini takip edip kazançlarını hesaplamalarına yardımcı olan bir Flutter uygulamasıdır.

## ✨ Ana Özellikler

### 1. **Maaş Ayarları**
- Saatlik veya aylık maaş giriş yapabilme
- Kazanç hesaplamalarının temeli
- Ayarları kolayca güncelleme

### 2. **Mesai Takvimi**
- Aylık takvim görünümü
- Mesai yapılan günleri işaretleme
- Her gün için mesai saati giriş yapma
- Aylık özeti görme (toplam saat, gün sayısı, tahmini kazanç)

### 3. **Gelir/Gider Yönetimi**
- Gelir ve gider işlemleri ekleme
- Tarih ve açıklama ile birlikte saklama
- **Gider çıkarılmış net bakiye** gösterimi
- **Gider çıkarılmamış toplam gelir** gösterimi
- İşlem listesini görüntüleme ve silme

### 4. **Ana Sayfa (Dashboard)**
- Toplam kazanç özeti
- Bakiye gösterimler
- Hızlı istatistikler
- Tüm sayfalar hızlı erişim düğmeleri

### 5. **Günlük Notlar**
- Tarihli notlar ekleme/düzenleme
- Notları liste halinde görüntüleme
- Notu silme özelliği
- Her tarihe farklı notlar

## 🏗️ Teknik Mimari

### Veri Modelleri

#### `SalarySettings`
```dart
- amount: double (Maaş tutarı)
- type: SalaryType (Hourly / Monthly)
```

#### `OvertimeEntry`
```dart
- date: DateTime (Tarih)
- hours: double (Mesai saati)
```

#### `IncomeExpense`
```dart
- id: String (Benzersiz kimlik)
- date: DateTime (İşlem tarihi)
- description: String (Açıklama)
- amount: double (Miktar)
- isIncome: bool (Gelir/Gider)
```

#### `Note`
```dart
- id: String (Benzersiz kimlik)
- date: DateTime (Not tarihi)
- content: String (Not içeriği)
- createdAt: DateTime (Oluşturulma tarihi)
```

### Veri Saklama
- **SharedPreferences** kullanımı
- JSON serileştirme
- Offline çalışma desteği
- Otomatik yükleme/kaydetme

### Sayfa Yapısı (TabBar Navigasyonu)

1. **HomePage** - Ana sayfa (Özet ve hızlı erişim)
2. **SalarySettingsPage** - Maaş ayarları
3. **OvertimeCalendarPage** - Mesai takvimi
4. **IncomeExpensePage** - Gelir/Gider
5. **NotesPage** - Günlük notlar

## 📊 Hesaplama Formülleri

### Saatlik Maaş
```
Günlük Kazanç = Mesai Saati × Saatlik Maaş
```

### Aylık Maaş
```
Günlük Kazanç = (Mesai Saati / 8) × (Aylık Maaş / 30)
```

### Net Bakiye
```
Net Bakiye = Toplam Gelir - Toplam Gider
```

### Gider Çıkarılmamış Bakiye
```
Gider Çıkarılmamış = Toplam Gelir
```

## 🎨 Tasarım Özellikleri

- **Material Design 3** kullanımı
- **Responsive** ve kullanıcı dostu arayüz
- **Renkli kart tasarımları**
  - Ana Sayfa: Mavi
  - Maaş Ayarları: Mavi
  - Mesai Takvimi: Yeşil
  - Gelir/Gider: Turuncu
  - Notlar: Mor
- **Sürüşken (Swipe) navigasyon**
- **Alt sekme (Bottom Tab Bar)** menüsü

## 🚀 Başlangıç

### Kurulum
```bash
cd dakikadeger
flutter pub get
flutter run -d windows  # veya -d chrome, -d edge
```

### İlk Kullanım Adımları
1. **Maaş Ayarlarını Yapılandır** - Saatlik/aylık maaşı gir
2. **Mesai Takvimini Doldur** - Mesai yapılan günleri işaretle
3. **Gelir/Gider Ekle** - Ek gelir ve giderleri kaydedi
4. **Notlar Al** - Günlük notlarını tut

## 📱 Desteklenen Platformlar

- ✅ Windows Desktop
- ✅ Web (Chrome, Edge)
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Linux

## 📋 Dosya Yapısı

```
lib/
├── main.dart                          # Ana giriş noktası
├── models/
│   ├── salary_settings.dart          # Maaş ayarları modeli
│   ├── overtime_entry.dart           # Mesai girişi modeli
│   ├── income_expense.dart           # Gelir/Gider modeli
│   └── note.dart                     # Not modeli
├── services/
│   └── data_service.dart             # Veri saklama servisi
├── pages/
│   ├── home_page.dart                # Ana sayfa
│   ├── salary_settings_page.dart     # Maaş ayarları sayfası
│   ├── overtime_calendar_page.dart   # Mesai takvimi sayfası
│   ├── income_expense_page.dart      # Gelir/Gider sayfası
│   └── notes_page.dart               # Notlar sayfası
└── extensions/
    └── list_extensions.dart          # List uzantıları
```

## 🔧 Bağımlılıklar

- **flutter**: SDK
- **shared_preferences**: ^2.2.2 (Yerel veri saklama)
- **intl**: ^0.20.2 (Tarih/saat ve para birimi biçimlendirmesi)

## 💡 Kullanım İpuçları

### Mesai Takvimi
- Takvim üzerindeki herhangi bir güne tıklayarak mesai saati girin
- Mesai saatini 0 olarak ayarlayarak günü silin
- Önceki/sonraki aylara geçmek için ok düğmelerini kullanın

### Gelir/Gider
- Gelir ve gideri ayır olarak girin
- Neden para çıktığını/girdiğini açıklamaya özen gösterin
- Bakiye kartlarını kontrol ederek finansal durumunuzu izleyin

### Notlar
- Her gün için farklı notlar tutabilirsiniz
- Notları tarihe göre sıralanmış olarak görürsünüz
- Uzun notları kısaltılmış şekilde görürsünüz (tam görmek için dokunun)

## 🐛 Sorun Giderme

### Veriler Kaydetilmiyor
- Uygulamayı kapatıp yeniden açmayı deneyin
- SharedPreferences'ın cihazda etkinleştirildiğinden emin olun

### Hesaplamalar Yanlış Görünüyor
- Maaş ayarlarının doğru olduğunu kontrol edin
- Mesai saatlerinin doğru girildiğini doğrulayın

### Arayüz Yavaş
- Uygulamayı kapatıp yeniden açın
- Çok sayıda işlem varsa eski olanları silin

## 📝 Notlar

- Uygulama tamamen offline çalışır
- Tüm veriler cihazda depolanır
- Cloud senkronizasyon şu anda desteklenmiyor
- Düzenli yedekleme almanız önerilir

## 🎓 Öğrenme Kaynakları

Bu uygulama şu Flutter konseptlerini kullanır:
- StatefulWidget ve StatelessWidget
- TabBar navigasyon
- Dialog ve AlertDialog
- Form yönetimi
- Local storage (SharedPreferences)
- JSON serileştirmesi
- Date/Time işlemleri
- Material Design prensipleri

## 📄 Lisans

Bu proje özel kullanım içindir.

---

**Sürüm:** 1.0.0  
**Son Güncelleme:** November 2025
