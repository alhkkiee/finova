import 'package:flutter/material.dart';

class Trx {
  final DateTime tanggal;
  final String deskripsi, kategori;
  final bool masuk;
  final int nominal;
  Trx(this.tanggal, this.deskripsi, this.kategori, this.masuk, this.nominal);
}

class Artikel {
  final String judul, chip, filter;
  final int menit;
  const Artikel(this.judul, this.chip, this.filter, this.menit);
}

class Soal {
  final String topik, tanya;
  final List<String> opsi;
  final int benar;
  const Soal(this.topik, this.tanya, this.opsi, this.benar);
}

String rp(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp$b';
}

const _bln = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
const _blnPanjang = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
String tgl(DateTime d) => '${d.day.toString().padLeft(2, '0')} ${_bln[d.month - 1]} ${d.year}';
String tglPanjang(DateTime d) => '${d.day} ${_blnPanjang[d.month - 1]} ${d.year}';

/// State sementara (in-memory). Ganti dengan koneksi MySQL nanti.
class AppState extends ChangeNotifier {
  static final AppState I = AppState._();
  AppState._();

  String namaLengkap = 'Syamil Al Haidar';
  String nama = 'Syamil';
  String email = 'syamilal@email.com';

  String get inisial {
    final p = namaLengkap.trim().split(RegExp(r'\s+'));
    return (p.first[0] + (p.length > 1 ? p.last[0] : '')).toUpperCase();
  }

  final List<String> kategori = ['Gaji', 'Hiburan', 'Makanan', 'Investasi', 'Transportasi', 'Tagihan'];

  final List<Trx> transaksi = [
    Trx(DateTime(2026, 9, 18), 'Gaji bulanan', 'Gaji', true, 12500000),
    Trx(DateTime(2026, 9, 17), 'Belanja mingguan', 'Makanan', false, 684000),
    Trx(DateTime(2026, 9, 15), 'MRT & ojek online', 'Transportasi', false, 235500),
    Trx(DateTime(2026, 9, 12), 'Internet & listrik', 'Tagihan', false, 1285000),
    Trx(DateTime(2026, 9, 10), 'Nonton bioskop', 'Hiburan', false, 180000),
    Trx(DateTime(2026, 9, 8), 'Dividen saham', 'Investasi', true, 750000),
  ];

  void tambahTrx(Trx t) {
    transaksi.insert(0, t);
    notifyListeners();
  }

  void tambahKategori(String k) {
    if (k.trim().isEmpty || kategori.contains(k.trim())) return;
    kategori.add(k.trim());
    notifyListeners();
  }

  void hapusKategori(String k) {
    kategori.remove(k);
    notifyListeners();
  }

  void simpanProfil(String n, String e) {
    nama = n;
    email = e;
    notifyListeners();
  }
}

const artikelList = [
  Artikel('Membangun Dana Darurat dari Nol', 'Perencanaan', 'Menabung', 8),
  Artikel('Cara Membuat Anggaran 50/30/20', 'Anggaran', 'Anggaran', 10),
  Artikel('Mengenal Reksa Dana untuk Pemula', 'Investasi', 'Investasi', 12),
  Artikel('Utang Produktif vs Konsumtif', 'Utang', 'Utang', 7),
];

const soalList = [
  Soal('Dana darurat ideal', 'Berapa jumlah dana darurat yang ideal untuk seseorang yang belum memiliki tanggungan?',
      ['1 bulan pengeluaran', '3–6 bulan pengeluaran', '12 bulan pendapatan', 'Sebesar limit kartu kredit'], 1),
  Soal('Bunga majemuk', 'Apa yang dimaksud dengan bunga majemuk?',
      ['Bunga dihitung hanya dari pokok', 'Bunga dihitung dari pokok ditambah bunga sebelumnya', 'Bunga tetap setiap tahun', 'Biaya administrasi bulanan'], 1),
  Soal('Rasio utang sehat', 'Berapa batas sehat cicilan utang terhadap penghasilan bulanan?',
      ['Maksimal 30%', 'Minimal 60%', 'Maksimal 80%', 'Tidak ada batas'], 0),
  Soal('Diversifikasi investasi', 'Tujuan utama diversifikasi investasi adalah...',
      ['Menjamin untung besar', 'Menyebar risiko', 'Menghindari pajak', 'Mempercepat pencairan'], 1),
  Soal('Risiko inflasi', 'Apa dampak inflasi terhadap uang tunai yang disimpan?',
      ['Nilainya naik', 'Daya belinya menurun', 'Tidak berubah', 'Bertambah otomatis'], 1),
  Soal('Anggaran 50/30/20', 'Pada aturan 50/30/20, angka 20 dialokasikan untuk...',
      ['Kebutuhan', 'Keinginan', 'Tabungan dan investasi', 'Hiburan'], 2),
  Soal('Reksa dana pasar uang', 'Reksa dana pasar uang paling cocok untuk tujuan...',
      ['Jangka pendek berisiko rendah', 'Spekulasi tinggi', 'Jangka panjang 20 tahun', 'Menggandakan modal cepat'], 0),
  Soal('Utang produktif', 'Contoh utang produktif adalah...',
      ['Cicilan gadget untuk gaya hidup', 'Modal usaha yang menghasilkan pendapatan', 'Kartu kredit untuk belanja impulsif', 'Pinjaman liburan'], 1),
  Soal('Proteksi', 'Fungsi utama asuransi adalah...',
      ['Sarana investasi tercepat', 'Mengalihkan risiko keuangan', 'Mengurangi pengeluaran harian', 'Menambah penghasilan'], 1),
  Soal('Kebiasaan menabung', 'Cara terbaik menjaga konsistensi menabung adalah...',
      ['Menabung sisa uang di akhir bulan', 'Transfer otomatis saat menerima pendapatan', 'Menabung saat sempat', 'Menunggu bonus'], 1),
];
