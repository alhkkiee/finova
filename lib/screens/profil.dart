import 'package:flutter/material.dart';
import '../data.dart';
import '../theme.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late final _nama = TextEditingController(text: AppState.I.nama);
  late final _email = TextEditingController(text: AppState.I.email);

  void _simpan() {
    if (_nama.text.trim().isEmpty || _email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan email wajib diisi')));
      return;
    }
    AppState.I.simpanProfil(_nama.text.trim(), _email.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/profil',
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PageHeader('Profil', 'Kelola informasi akun Anda'),
            Panel(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Field('Nama Tampilan', controller: _nama),
                const SizedBox(height: 16),
                Field('Email', controller: _email, type: TextInputType.emailAddress),
                const SizedBox(height: 20),
                PrimaryButton('Simpan Profil', color: C.primary, onTap: _simpan),
              ]),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD6DB)),
              ),
              child: Row(children: [
                const Icon(Icons.logout_rounded, color: C.red, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Keluar dari akun', style: ts(13, w: FontWeight.w700, c: C.red)),
                    Text('Sesi pada perangkat ini akan diakhiri.', style: ts(11, c: C.muted)),
                  ]),
                ),
                TextButton.icon(
                  onPressed: () => confirmLogout(context),
                  icon: const Icon(Icons.logout_rounded, color: C.red, size: 16),
                  label: Text('Logout', style: ts(13, w: FontWeight.w600, c: C.red)),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
