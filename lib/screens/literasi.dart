import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

// ───────────────────────── DAFTAR MATERI ─────────────────────────
class LiterasiPage extends StatefulWidget {
  const LiterasiPage({super.key});
  @override
  State<LiterasiPage> createState() => _LiterasiPageState();
}

class _LiterasiPageState extends State<LiterasiPage> {
  String _q = '', _filter = 'Semua';
  static const _chips = ['Semua', 'Anggaran', 'Menabung', 'Investasi', 'Utang', 'Proteksi'];

  void _buka(Artikel a) => Navigator.push(context, MaterialPageRoute(builder: (_) => ArtikelDetailPage(a)));

  Widget _kartu(Artikel a, double w) => SizedBox(
        width: w,
        child: InkWell(
          onTap: () => _buka(a),
          borderRadius: BorderRadius.circular(16),
          child: Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: C.softBlue, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.insert_chart_outlined, color: C.primary),
              ),
              const SizedBox(height: 14),
              Tag(a.chip),
              const SizedBox(height: 10),
              Text(a.judul, style: ts(14, w: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('${a.menit} menit baca', style: ts(11, c: C.muted)),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final list = artikelList.where((a) {
      final okQ = _q.isEmpty || a.judul.toLowerCase().contains(_q.toLowerCase());
      final okF = _filter == 'Semua' || a.filter == _filter;
      return okQ && okF;
    }).toList();

    return AppShell(
      route: '/literasi',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PageHeader('Pusat Literasi Keuangan', 'Materi praktis untuk keputusan finansial yang lebih percaya diri'),
        Cols(flex: const [3, 1], breakpoint: 800, children: [
          Panel(
            child: Field('Cari materi',
                hint: 'Cari artikel, topik, atau kategori...',
                suffix: const Icon(Icons.search, size: 18),
                onChanged: (v) => setState(() => _q = v)),
          ),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Progress belajar', style: ts(12)),
                const Spacer(),
                Text('62%', style: ts(12, w: FontWeight.w700, c: C.primary)),
              ]),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(value: .62, minHeight: 6, color: C.primary, backgroundColor: C.border),
              ),
              const SizedBox(height: 8),
              Text('8 dari 13 materi selesai', style: ts(11, c: C.muted)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Panel(
          child: Cols(flex: const [2, 3], breakpoint: 700, gap: 24, children: [
            Container(
              height: 170,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: C.navyDark, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.menu_book_outlined, color: C.primary, size: 48),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Tag('Artikel unggulan'),
              const SizedBox(height: 12),
              Text('Fondasi Keuangan Sehat: Mulai dari Mana?', style: ts(24)),
              const SizedBox(height: 10),
              Text('Panduan langkah demi langkah untuk mengatur arus kas, dana darurat, dan tujuan keuangan pertamamu.',
                  style: ts(13, c: C.muted)),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _buka(artikelList.first),
                child: Text('Baca 9 menit →', style: ts(12, w: FontWeight.w700, c: C.primary)),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final c in _chips)
            ChoiceChip(
              label: Text(c, style: ts(12, c: _filter == c ? Colors.white : C.muted)),
              selected: _filter == c,
              selectedColor: C.navyDark,
              backgroundColor: Colors.white,
              showCheckmark: false,
              onSelected: (_) => setState(() => _filter = c),
            ),
        ]),
        const SizedBox(height: 16),
        LayoutBuilder(builder: (context, c) {
          final n = c.maxWidth >= 900 ? 4 : (c.maxWidth >= 560 ? 2 : 1);
          final w = (c.maxWidth - 16 * (n - 1)) / n;
          return Wrap(spacing: 16, runSpacing: 16, children: [for (final a in list) _kartu(a, w)]);
        }),
      ]),
    );
  }
}

// ───────────────────────── DETAIL ARTIKEL ─────────────────────────
class ArtikelDetailPage extends StatelessWidget {
  final Artikel artikel;
  const ArtikelDetailPage(this.artikel, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/literasi',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Text('Literasi / Perencanaan Keuangan', style: ts(12, c: C.primary)),
        ),
        const SizedBox(height: 8),
        Tag(artikel.chip),
        const SizedBox(height: 10),
        Text('Membangun Dana Darurat: Fondasi Keuangan yang Tangguh', style: ts(30)),
        const SizedBox(height: 6),
        Text('Tim Edukasi Nava  •  ${artikel.menit} menit baca  •  18 Sep 2026', style: ts(12, c: C.muted)),
        const SizedBox(height: 20),
        Cols(flex: const [1, 3, 1], breakpoint: 900, children: [
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Daftar isi', style: ts(12, w: FontWeight.w700)),
              const SizedBox(height: 10),
              for (final t in const ['1. Mengapa perlu dana darurat?', '2. Berapa jumlah ideal?', '3. Cara memulai', '4. Tempat menyimpan'])
                Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Text(t, style: ts(12, c: C.primary))),
            ]),
          ),
          Panel(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Dana darurat adalah lapisan perlindungan pertama ketika hidup berjalan di luar rencana—mulai dari biaya kesehatan hingga kehilangan pemasukan.',
                  style: ts(18)),
              const SizedBox(height: 20),
              Text('Mengapa perlu dana darurat?', style: ts(22)),
              const SizedBox(height: 8),
              Text(
                  'Tanpa cadangan yang cukup, pengeluaran tak terduga dapat memaksa kita menggunakan kartu kredit atau menjual investasi pada waktu yang kurang tepat. Dana darurat menjaga tujuan jangka panjang tetap berada di jalurnya.',
                  style: ts(14, c: C.muted)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: C.softBlue, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.lightbulb_outline, color: C.muted, size: 20),
                  const SizedBox(width: 14),
                  Expanded(child: Text('Target awal yang realistis adalah satu bulan pengeluaran, lalu tingkatkan perlahan hingga 3–6 bulan.', style: ts(14))),
                ]),
              ),
              const SizedBox(height: 20),
              Text('Cara memulai dalam tiga langkah', style: ts(22)),
              const SizedBox(height: 8),
              Text(
                  'Hitung pengeluaran wajib bulanan, buat rekening terpisah, lalu aktifkan transfer otomatis setiap menerima pendapatan. Konsistensi lebih penting daripada nominal besar di awal.',
                  style: ts(14, c: C.muted)),
            ]),
          ),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Materi terkait', style: ts(12, w: FontWeight.w700)),
              const SizedBox(height: 10),
              for (final t in const ['Anggaran 50/30/20', 'Menetapkan tujuan finansial', 'Reksa dana pasar uang'])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t, style: ts(12)),
                    const SizedBox(height: 4),
                    Text('Baca artikel →', style: ts(11, c: C.primary)),
                  ]),
                ),
            ]),
          ),
        ]),
      ]),
    );
  }
}
