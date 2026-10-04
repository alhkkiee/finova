import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

// ───────────────────────── LOGIN ─────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _remember = false, _hide = true;
  String? _err;

  void _submit() {
    if (_email.text.trim().isEmpty || _pass.text.isEmpty) {
      setState(() => _err = 'Email dan kata sandi wajib diisi');
      return;
    }
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  Widget _left() => Container(
        color: C.navy,
        padding: const EdgeInsets.all(40),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Logo(),
          const Spacer(),
          Text('PAHAMI KEUANGANMU, KELOLA MASA DEPANMU.', style: ts(11, c: const Color(0xFF9FB4FF))),
          const SizedBox(height: 16),
          Text('Tak sekadar mencatat transaksi, pelajari strategi mengelola arus kas dengan mudah dan menyenangkan.',
              style: ts(38, w: FontWeight.w800, c: Colors.white)),
          const SizedBox(height: 16),
          Text('Kelola produk, customer, dan pembayaran dengan data yang selalu siap ditindaklanjuti.',
              style: ts(14, c: Colors.white60)),
          const SizedBox(height: 20),
          Wrap(spacing: 24, runSpacing: 8, children: [
            for (final t in ['1.248 transaksi', '99,9% uptime', 'Data terenkripsi'])
              Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF9FB4FF)),
                const SizedBox(width: 6),
                Text(t, style: ts(12, c: Colors.white60)),
              ]),
          ]),
          const Spacer(),
          Text('© 2026 The Pencengs Teknologi Indonesia', style: ts(11, c: Colors.white38)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (ctx, c) {
        final form = Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Selamat datang kembali', style: ts(28, w: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Masuk untuk melanjutkan ke workspace Anda.', style: ts(13, c: C.muted)),
                const SizedBox(height: 20),
                Field('Email', controller: _email, type: TextInputType.emailAddress, hint: 'nama@email.com'),
                const SizedBox(height: 14),
                Field('Kata sandi',
                    controller: _pass,
                    obscure: _hide,
                    hint: '••••••••',
                    error: _err,
                    suffix: IconButton(
                      icon: Icon(_hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18),
                      onPressed: () => setState(() => _hide = !_hide),
                    )),
                const SizedBox(height: 8),
                Row(children: [
                  Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                  Text('Ingat saya', style: ts(13, c: C.muted)),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/lupa-password'),
                    child: Text('Lupa kata sandi?', style: ts(13, w: FontWeight.w700, c: C.primary)),
                  ),
                ]),
                const SizedBox(height: 12),
                PrimaryButton('Masuk ke dashboard', icon: Icons.arrow_forward, onTap: _submit),
                const SizedBox(height: 16),
                LinkText('Belum punya akun?', 'Daftar sekarang', () => Navigator.pushNamed(context, '/register')),
              ]),
            ),
          ),
        );
        if (c.maxWidth < 800) return form;
        return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(flex: 2, child: _left()),
          Expanded(flex: 3, child: form),
        ]);
      }),
    );
  }
}

// ───────────────────────── REGISTRASI ─────────────────────────
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nama = TextEditingController();
  final _bisnis = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _conf = TextEditingController();
  bool _agree = false;

  bool get _lenOk => _pass.text.length >= 8;
  bool get _caseOk => RegExp(r'\d').hasMatch(_pass.text) && RegExp(r'[A-Z]').hasMatch(_pass.text);
  bool get _symOk => RegExp(r'[^A-Za-z0-9]').hasMatch(_pass.text);
  bool get _match => _pass.text == _conf.text;
  bool get _valid =>
      _nama.text.trim().isNotEmpty && _email.text.trim().isNotEmpty && _lenOk && _caseOk && _symOk && _match && _agree;

  void _submit() {
    AppState.I.namaLengkap = _nama.text.trim();
    AppState.I.nama = _nama.text.trim().split(' ').first;
    AppState.I.email = _email.text.trim();
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  Widget _rule(String t, bool ok) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(children: [
          Icon(ok ? Icons.check_circle : Icons.check_circle_outline, size: 15, color: ok ? C.green : C.muted),
          const SizedBox(width: 8),
          Text(t, style: ts(12, c: ok ? C.green : C.muted)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final r = () => setState(() {});
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (ctx, c) {
        final form = Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Buat akun baru', style: ts(28, w: FontWeight.w800)),
                const SizedBox(height: 4),
                Text('Mulai kelola proses penjualan bisnis Anda.', style: ts(13, c: C.muted)),
                const SizedBox(height: 20),
                Cols(breakpoint: 480, children: [
                  Field('Nama lengkap', controller: _nama, onChanged: (_) => r()),
                  Field('Nama bisnis', controller: _bisnis),
                ]),
                const SizedBox(height: 14),
                Field('Email bisnis', controller: _email, type: TextInputType.emailAddress, onChanged: (_) => r()),
                const SizedBox(height: 14),
                Cols(breakpoint: 480, children: [
                  Field('Kata sandi', controller: _pass, obscure: true, onChanged: (_) => r()),
                  Field('Konfirmasi kata sandi',
                      controller: _conf,
                      obscure: true,
                      onChanged: (_) => r(),
                      error: (_conf.text.isNotEmpty && !_match) ? 'Kata sandi belum sama' : null),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: C.softBlue.withOpacity(.6), borderRadius: BorderRadius.circular(10)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _rule('Minimal 8 karakter', _lenOk),
                    _rule('Memiliki angka dan huruf besar', _caseOk),
                    _rule('Gunakan simbol khusus', _symOk),
                  ]),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Checkbox(value: _agree, onChanged: (v) => setState(() => _agree = v ?? false)),
                  Expanded(child: Text('Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi The Pencengs.', style: ts(12, c: C.muted))),
                ]),
                const SizedBox(height: 12),
                PrimaryButton('Buat akun dan lanjutkan', icon: Icons.arrow_forward, onTap: _valid ? _submit : null),
                const SizedBox(height: 16),
                LinkText('Sudah memiliki akun?', 'Masuk', () => Navigator.pushReplacementNamed(context, '/login')),
              ]),
            ),
          ),
        );
        if (c.maxWidth < 800) return form;
        return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            width: 300,
            color: C.navy,
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Logo(),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: C.navyDark, borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.shield_outlined, color: Colors.white70, size: 18),
                  const SizedBox(height: 8),
                  Text('Data Anda aman', style: ts(13, w: FontWeight.w600, c: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Kami menggunakan enkripsi untuk melindungi informasi bisnis Anda.', style: ts(11, c: Colors.white54)),
                ]),
              ),
              const Spacer(),
              Text('© 2026 The Pencengs Teknologi Indonesia', style: ts(11, c: Colors.white38)),
            ]),
          ),
          Expanded(child: form),
        ]);
      }),
    );
  }
}

// ───────────────────────── LUPA PASSWORD ─────────────────────────
class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});
  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final _email = TextEditingController();

  void _kirim() {
    if (_email.text.trim().isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode OTP dikirim ke ${_email.text.trim()}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.navy,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Text('Lupa Password', style: ts(34, w: FontWeight.w800))),
                const SizedBox(height: 6),
                Center(child: Text('Masukan email Anda dan tunggu kode OTP akan dikirim', textAlign: TextAlign.center, style: ts(14))),
                const SizedBox(height: 40),
                Field('Email', controller: _email, type: TextInputType.emailAddress),
                const SizedBox(height: 24),
                PrimaryButton('Kirim', icon: Icons.arrow_forward, onTap: _kirim),
                const SizedBox(height: 12),
                LinkText('Belum punya akun?', 'Daftar sekarang', () => Navigator.pushReplacementNamed(context, '/register')),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
