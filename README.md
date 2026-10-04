# Finova

Aplikasi pencatat transaksi keuangan yang dilengkapi pusat literasi dan kuis keuangan.

## Fitur
- Registrasi, login, lupa password (OTP), logout
- Dashboard ringkasan keuangan (saldo, arus kas, distribusi kategori)
- Transaksi: daftar + filter, tambah transaksi, tambah/hapus kategori (master data)
- Literasi keuangan: daftar materi, pencarian, filter kategori, detail artikel
- Kuis keuangan 10 soal + hasil dan rekomendasi materi
- Profil pengguna

## Cara menjalankan
```
flutter run -d web-server --web-port 8080
buka localhost:8080 diChrome 
```

## Struktur
```
lib/main.dart           
lib/theme.dart           
lib/data.dart            
lib/screens/auth.dart    
lib/screens/dashboard.dart
lib/screens/transaksi.dart
lib/screens/literasi.dart
lib/screens/kuis.dart
lib/screens/profil.dart
```

## Tim
Muhammad Syamil Al Haidar 25082010195
Septyan Fernando Umbara 25082010204
Muhammad Alvin Fanny Hafizh 25082010214
Muhammad Hakam Al haqqi 25082010216
