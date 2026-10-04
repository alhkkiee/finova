import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const _masuk = [.55, .80, .62, .95, .82, 1.0];
  static const _keluar = [.32, .50, .40, .58, .50, .62];
  static const _bulan = ['Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep'];

  Widget _bar(double h, Color c) => Container(
        width: 18,
        height: h,
        decoration: BoxDecoration(color: c, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      );

  Widget _item(IconData ic, String t, String sub, String nominal, Color c) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(ic, color: C.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t, style: ts(14, w: FontWeight.w700)),
              Text(sub, style: ts(11, c: C.muted)),
            ]),
          ),
          Text(nominal, style: ts(14, w: FontWeight.w700, c: c)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/dashboard',
      child: ListenableBuilder(
        listenable: AppState.I,
        builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PageHeader('Selamat pagi, ${AppState.I.nama}', 'Berikut kondisi keuanganmu pada September 2026',
              action: PrimaryButton('Tambah transaksi',
                  icon: Icons.add, color: C.primary, onTap: () => Navigator.pushNamed(context, '/tambah-transaksi'))),
          Cols(breakpoint: 600, children: [
            StatCard('Total saldo', 'Rp28.450.000', C.primary),
            StatCard('Pemasukan bulan ini', 'Rp15.250.000', C.green),
            StatCard('Pengeluaran bulan ini', 'Rp8.375.500', C.red),
          ]),
          const SizedBox(height: 16),
          Cols(flex: const [3, 1], breakpoint: 800, children: [
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Arus kas 6 bulan', style: ts(15, w: FontWeight.w700)),
                  const Spacer(),
                  const Tag('Mar-Sep 2026'),
                ]),
                const SizedBox(height: 20),
                SizedBox(
                  height: 210,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    for (var i = 0; i < 6; i++)
                      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          _bar(_masuk[i] * 170, C.green),
                          const SizedBox(width: 6),
                          _bar(_keluar[i] * 170, C.red),
                        ]),
                        const SizedBox(height: 8),
                        Text(_bulan[i], style: ts(11, c: C.muted)),
                      ]),
                  ]),
                ),
              ]),
            ),
            Panel(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Distribusi kategori', style: ts(15, w: FontWeight.w700)),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: CustomPaint(
                      painter: DonutPainter(const [32, 26, 18, 24],
                          const [Color(0xFF2F6BF0), Color(0xFF5A8CF5), Color(0xFF86AAF8), Color(0xFFB4CAFA)]),
                      child: Center(child: Text('Rp8,3 jt', style: ts(14, w: FontWeight.w800))),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (final e in const [('Makanan', '32%'), ('Tagihan', '26%'), ('Investasi', '18%'), ('Lainnya', '24%')])
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [
                      Text(e.$1, style: ts(12, c: C.muted)),
                      const Spacer(),
                      Text(e.$2, style: ts(12, c: C.muted)),
                    ]),
                  ),
              ]),
            ),
          ]),
          const SizedBox(height: 16),
          Panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('Transaksi terbaru', style: ts(15, w: FontWeight.w700)),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.pushReplacementNamed(context, '/transaksi'),
                  child: Text('Lihat semua', style: ts(12, c: C.primary)),
                ),
              ]),
              const SizedBox(height: 8),
              _item(Icons.cancel_outlined, 'Gaji bulanan', 'Gaji · 18 Sep 2026', '+ Rp12.500.000', C.green),
              _item(Icons.cancel_outlined, 'Kopi & makan siang', 'Makanan · 18 Sep 2026', '- Rp185.000', C.red),
              _item(Icons.local_shipping_outlined, 'Transportasi online', 'Transportasi · 18 Sep 2026', '- Rp72.500', C.red),
              _item(Icons.show_chart_rounded, 'Reksa dana pasar uang', 'Investasi · 18 Sep 2026', '- Rp1.500.000', C.red),
            ]),
          ),
        ]),
      ),
    );
  }
}
