import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});
  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  int _i = 0;
  bool _selesai = false;
  late List<int?> _jawab = List.filled(soalList.length, null);

  int get _benar {
    var n = 0;
    for (var i = 0; i < soalList.length; i++) {
      if (_jawab[i] == soalList[i].benar) n++;
    }
    return n;
  }

  void _ulang() => setState(() {
        _i = 0;
        _selesai = false;
        _jawab = List.filled(soalList.length, null);
      });

  @override
  Widget build(BuildContext context) {
    return AppShell(route: '/kuis', child: _selesai ? _hasil() : _soal());
  }

  // ───────── Halaman soal ─────────
  Widget _soal() {
    final s = soalList[_i];
    final n = soalList.length;
    final last = _i == n - 1;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageHeader('Kuis Literasi Keuangan', 'Uji pemahamanmu tentang dasar pengelolaan uang'),
      Panel(
        child: Column(children: [
          Row(children: [
            Text('Pertanyaan ${_i + 1} dari $n', style: ts(12)),
            const Spacer(),
            Tag('${((_i + 1) * 100 / n).round()}% selesai'),
          ]),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: (_i + 1) / n, minHeight: 6, color: C.primary, backgroundColor: C.border),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Panel(
            padding: const EdgeInsets.all(28),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Tag(s.topik),
              const SizedBox(height: 12),
              Text(s.tanya, style: ts(22, w: FontWeight.w800)),
              const SizedBox(height: 16),
              for (var k = 0; k < s.opsi.length; k++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _jawab[_i] = k),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: _jawab[_i] == k ? C.softBlue : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _jawab[_i] == k ? C.primary : C.border),
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 11,
                          backgroundColor: _jawab[_i] == k ? C.primary : C.border,
                          child: Text(String.fromCharCode(65 + k),
                              style: ts(11, w: FontWeight.w700, c: _jawab[_i] == k ? Colors.white : C.muted)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(s.opsi[k], style: ts(14))),
                      ]),
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                OutlineBtn('Sebelumnya', icon: Icons.arrow_back, onTap: _i == 0 ? null : () => setState(() => _i--)),
                PrimaryButton(last ? 'Selesai' : 'Selanjutnya',
                    icon: Icons.arrow_forward,
                    color: C.primary,
                    onTap: _jawab[_i] == null ? null : () => setState(() => last ? _selesai = true : _i++)),
              ]),
            ]),
          ),
        ),
      ),
    ]);
  }

  // ───────── Halaman hasil ─────────
  Widget _hasil() {
    final b = _benar;
    final n = soalList.length;
    final skor = (b * 100 / n).round();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageHeader('Hasil Kuis', 'Ringkasan pemahaman literasi keuanganmu'),
      Cols(flex: const [2, 3], breakpoint: 800, children: [
        Panel(
          child: Column(children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CustomPaint(
                painter: RingPainter(skor / 100, C.green),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$skor', style: ts(38, w: FontWeight.w800)),
                    Text('dari 100', style: ts(11, c: C.muted)),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(skor >= 70 ? 'Bagus! Pemahamanmu kuat.' : 'Ayo pelajari lagi materinya.',
                style: ts(15, w: FontWeight.w700, c: skor >= 70 ? C.green : C.red)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Tag('$b benar', bg: C.green.withOpacity(.12), fg: C.green),
              Tag('${n - b} salah', bg: C.red.withOpacity(.12), fg: C.red),
            ]),
          ]),
        ),
        Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Tinjauan jawaban', style: ts(15, w: FontWeight.w700)),
            const SizedBox(height: 8),
            for (var i = 0; i < n; i++)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.border))),
                child: Row(children: [
                  Expanded(child: Text(soalList[i].topik, style: ts(13))),
                  _jawab[i] == soalList[i].benar
                      ? Tag('Benar', bg: C.green.withOpacity(.12), fg: C.green)
                      : Tag('Salah', bg: C.red.withOpacity(.12), fg: C.red),
                ]),
              ),
          ]),
        ),
      ]),
      const SizedBox(height: 16),
      Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Rekomendasi materi untukmu', style: ts(15, w: FontWeight.w700)),
          const SizedBox(height: 12),
          Cols(breakpoint: 700, children: [
            for (final r in const [('Mengelola Rasio Utang', '6 menit baca'), ('Inflasi dan Nilai Uang', '8 menit baca'), ('Dasar Diversifikasi', '7 menit baca')])
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFF1F5FC), borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.menu_book_outlined, color: C.primary, size: 20),
                  const SizedBox(height: 10),
                  Text(r.$1, style: ts(13)),
                  const SizedBox(height: 4),
                  Text(r.$2, style: ts(11, c: C.muted)),
                ]),
              ),
          ]),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.spaceBetween, children: [
            OutlineBtn('Kembali ke literasi', onTap: () => Navigator.pushReplacementNamed(context, '/literasi')),
            PrimaryButton('Coba lagi', icon: Icons.refresh, color: C.primary, onTap: _ulang),
          ]),
        ]),
      ),
    ]);
  }
}
