import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/auth.dart';
import 'screens/dashboard.dart';
import 'screens/transaksi.dart';
import 'screens/literasi.dart';
import 'screens/kuis.dart';
import 'screens/profil.dart';

void main() => runApp(const FinovaApp());

class FinovaApp extends StatelessWidget {
  const FinovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: C.bg,
        colorScheme: ColorScheme.fromSeed(seedColor: C.primary),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/lupa-password': (_) => const ForgotPage(),
        '/dashboard': (_) => const DashboardPage(),
        '/transaksi': (_) => const TransaksiPage(),
        '/tambah-transaksi': (_) => const TambahTransaksiPage(),
        '/literasi': (_) => const LiterasiPage(),
        '/kuis': (_) => const KuisPage(),
        '/profil': (_) => const ProfilPage(),
      },
    );
  }
}
