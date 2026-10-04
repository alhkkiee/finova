# Finova

Aplikasi pencatat transaksi keuangan yang dilengkapi pusat literasi dan kuis keuangan.
Slicing UI Flutter dari desain Figma (auth, CRUD master data kategori/transaksi, literasi, kuis, profil).

## Fitur
- Registrasi, login, lupa password (OTP), logout
- Dashboard ringkasan keuangan (saldo, arus kas, distribusi kategori)
- Transaksi: daftar + filter, tambah transaksi, tambah/hapus kategori (master data)
- Literasi keuangan: daftar materi, pencarian, filter kategori, detail artikel
- Kuis keuangan 10 soal + hasil dan rekomendasi materi
- Profil pengguna

## Cara menjalankan
```
flutter pub get
flutter run -d chrome
```

## Struktur
```
lib/main.dart            routing
lib/theme.dart           warna, widget bersama, sidebar
lib/data.dart            model + data dummy (state sementara, belum MySQL)
lib/screens/auth.dart    login, registrasi, lupa password
lib/screens/dashboard.dart
lib/screens/transaksi.dart
lib/screens/literasi.dart
lib/screens/kuis.dart
lib/screens/profil.dart
```

## Tim
| NPM | Nama | Pembagian tugas |
|-----|------|-----------------|
| ... | ...  | ...             |
