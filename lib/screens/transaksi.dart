import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../theme.dart';

// ───────────────────────── DAFTAR TRANSAKSI ─────────────────────────
class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});
  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  String _q = '', _jenis = 'Semua jenis', _kat = 'Semua kategori';

  Widget _head(String t, int flex) =>
      Expanded(flex: flex, child: Text(t, style: ts(11, w: FontWeight.w600, c: C.muted)));

  Widget _row(Trx t) {
    final c = t.masuk ? C.green : C.red;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: C.border))),
      child: Row(children: [
        Expanded(flex: 2, child: Text(tgl(t.tanggal), style: ts(13, c: C.muted))),
        Expanded(
          flex: 3,
          child: Row(children: [
            const Icon(Icons.receipt_long_outlined, size: 16, color: C.primary),
            const SizedBox(width: 8),
            Flexible(child: Text(t.deskripsi, style: ts(14, w: FontWeight.w700))),
          ]),
        ),
        Expanded(flex: 2, child: Text(t.kategori, style: ts(13, c: C.muted))),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Tag(t.masuk ? 'Pemasukan' : 'Pengeluaran',
                bg: c.withOpacity(.12), fg: c),
          ),
        ),
        Expanded(flex: 2, child: Text('${t.masuk ? '+' : '-'} ${rp(t.nominal)}', style: ts(14, w: FontWeight.w700, c: c))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/transaksi',
      child: ListenableBuilder(
        listenable: AppState.I,
        builder: (context, _) {
          final s = AppState.I;
          final list = s.transaksi.where((t) {
            final okQ = _q.isEmpty || t.deskripsi.toLowerCase().contains(_q.toLowerCase());
            final okJ = _jenis == 'Semua jenis' || (_jenis == 'Pemasukan') == t.masuk;
            final okK = _kat == 'Semua kategori' || t.kategori == _kat;
            return okQ && okJ && okK;
          }).toList();
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PageHeader('Transaksi', 'Telusuri dan kelola seluruh aktivitas keuangan',
                action: PrimaryButton('Tambah transaksi',
                    icon: Icons.add, color: C.primary, onTap: () => Navigator.pushNamed(context, '/tambah-transaksi'))),
            Cols(breakpoint: 600, children: [
              StatCard('Total transaksi', '${48 - 6 + s.transaksi.length}', C.primary),
              StatCard('Pemasukan', 'Rp15.250.000', C.green),
              StatCard('Pengeluaran', 'Rp8.375.500', C.red),
            ]),
            const SizedBox(height: 16),
            Panel(
              child: Cols(gap: 12, breakpoint: 700, children: [
                Field('Pencarian', hint: 'Cari transaksi...', suffix: const Icon(Icons.search, size: 18), onChanged: (v) => setState(() => _q = v)),
                Drop('Periode', 'September 2026', const ['September 2026', 'Agustus 2026'], (_) {}),
                Drop('Jenis', _jenis, const ['Semua jenis', 'Pemasukan', 'Pengeluaran'], (v) => setState(() => _jenis = v!)),
                Drop('Kategori', _kat, ['Semua kategori', ...s.kategori], (v) => setState(() => _kat = v!)),
              ]),
            ),
            const SizedBox(height: 16),
            Panel(
              child: LayoutBuilder(builder: (context, c) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: max(c.maxWidth, 720),
                    child: Column(children: [
                      Row(children: [_head('TANGGAL', 2), _head('DESKRIPSI', 3), _head('KATEGORI', 2), _head('JENIS', 2), _head('NOMINAL', 2)]),
                      const SizedBox(height: 12),
                      if (list.isEmpty)
                        Padding(padding: const EdgeInsets.all(24), child: Text('Tidak ada transaksi', style: ts(13, c: C.muted)))
                      else
                        for (final t in list) _row(t),
                    ]),
                  ),
                );
              }),
            ),
          ]);
        },
      ),
    );
  }
}

// ───────────────────────── TAMBAH TRANSAKSI ─────────────────────────
class TambahTransaksiPage extends StatefulWidget {
  const TambahTransaksiPage({super.key});
  @override
  State<TambahTransaksiPage> createState() => _TambahTransaksiPageState();
}

class _TambahTransaksiPageState extends State<TambahTransaksiPage> {
  final _nominal = TextEditingController();
  final _desk = TextEditingController();
  final _katBaru = TextEditingController();
  bool _masuk = true;
  String? _kat;
  DateTime _tanggal = DateTime.now();

  Widget _toggle(String t, IconData ic, bool isMasuk) {
    final on = _masuk == isMasuk;
    final c = isMasuk ? C.green : C.red;
    return InkWell(
      onTap: () => setState(() => _masuk = isMasuk),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: on ? c.withOpacity(.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: on ? c : C.border),
        ),
        child: Column(children: [
          Icon(ic, size: 18, color: on ? c : C.muted),
          const SizedBox(height: 4),
          Text(t, style: ts(13, c: on ? c : C.muted)),
        ]),
      ),
    );
  }

  Future<void> _pilihTanggal() async {
    final d = await showDatePicker(
        context: context, initialDate: _tanggal, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _tanggal = d);
  }

  void _simpan() {
    final n = int.tryParse(_nominal.text);
    if (n == null || n <= 0 || _kat == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal dan kategori wajib diisi')));
      return;
    }
    AppState.I.tambahTrx(Trx(_tanggal, _desk.text.trim().isEmpty ? _kat! : _desk.text.trim(), _kat!, _masuk, n));
    Navigator.pushReplacementNamed(context, '/transaksi');
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/transaksi',
      child: ListenableBuilder(
        listenable: AppState.I,
        builder: (context, _) {
          final s = AppState.I;
          if (_kat != null && !s.kategori.contains(_kat)) _kat = null;
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            PageHeader('Tambah transaksi', 'Catat pemasukan atau pengeluaran baru',
                action: OutlineBtn('Kembali', color: C.red, onTap: () => Navigator.pushReplacementNamed(context, '/transaksi'))),
            Cols(flex: const [2, 1], breakpoint: 800, children: [
              Panel(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Detail transaksi', style: ts(15, w: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _toggle('Pemasukan', Icons.arrow_downward, true)),
                    const SizedBox(width: 12),
                    Expanded(child: _toggle('Pengeluaran', Icons.arrow_upward, false)),
                  ]),
                  const SizedBox(height: 14),
                  Field('Nominal',
                      controller: _nominal,
                      hint: 'Rp 0',
                      type: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly]),
                  const SizedBox(height: 14),
                  Cols(breakpoint: 480, children: [
                    Drop('Kategori', _kat ?? '', s.kategori, (v) => setState(() => _kat = v), hint: 'Pilih kategori'),
                    Field('Tanggal',
                        readOnly: true,
                        onTap: _pilihTanggal,
                        controller: TextEditingController(text: tglPanjang(_tanggal)),
                        suffix: const Icon(Icons.calendar_today_outlined, size: 16)),
                  ]),
                  const SizedBox(height: 14),
                  Field('Deskripsi', controller: _desk, hint: 'Contoh: Gaji bulanan September'),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    OutlineBtn('Batal', onTap: () => Navigator.pushReplacementNamed(context, '/transaksi')),
                    PrimaryButton('Simpan transaksi', icon: Icons.check, color: C.primary, onTap: _simpan),
                  ]),
                ]),
              ),
              Panel(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Tambah kategori', style: ts(15, w: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Field('Nama kategori', controller: _katBaru),
                  const SizedBox(height: 12),
                  Row(children: [
                    OutlineBtn('Batal', onTap: () => _katBaru.clear()),
                    const SizedBox(width: 8),
                    PrimaryButton('Simpan kategori', color: C.primary, onTap: () {
                      s.tambahKategori(_katBaru.text);
                      _katBaru.clear();
                    }),
                  ]),
                  const SizedBox(height: 14),
                  for (final k in s.kategori)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.only(left: 14, right: 4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: C.border)),
                      child: Row(children: [
                        Expanded(child: Text(k, style: ts(14, w: FontWeight.w600))),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: C.red, size: 18),
                          onPressed: () => s.hapusKategori(k),
                        ),
                      ]),
                    ),
                ]),
              ),
            ]),
          ]);
        },
      ),
    );
  }
}
