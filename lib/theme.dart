import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data.dart';

class C {
  static const navy = Color(0xFF1F2080);
  static const navyDark = Color(0xFF111C3D);
  static const primary = Color(0xFF2F6BF0);
  static const btn = Color(0xFF2B2BE0);
  static const ink = Color(0xFF111B33);
  static const muted = Color(0xFF7A869A);
  static const green = Color(0xFF1B9E6B);
  static const red = Color(0xFFE5566D);
  static const bg = Color(0xFFF7F8FC);
  static const border = Color(0xFFE6E9F2);
  static const softBlue = Color(0xFFEAF0FF);
}

TextStyle ts(double size, {FontWeight w = FontWeight.w400, Color c = C.ink}) =>
    TextStyle(fontSize: size, fontWeight: w, color: c);

// ───────────────────────── Widget dasar ─────────────────────────

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: C.primary, borderRadius: BorderRadius.circular(8)),
          child: Text('F', style: ts(16, w: FontWeight.bold, c: Colors.white)),
        ),
        const SizedBox(width: 10),
        Text('Finova', style: ts(16, w: FontWeight.w600, c: Colors.white)),
      ]);
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel({super.key, required this.child, this.padding = const EdgeInsets.all(20)});
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.border),
          boxShadow: const [BoxShadow(color: Color(0x0F1F2080), blurRadius: 16, offset: Offset(0, 4))],
        ),
        child: child,
      );
}

class Tag extends StatelessWidget {
  final String text;
  final Color bg, fg;
  const Tag(this.text, {super.key, this.bg = C.softBlue, this.fg = C.primary});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: ts(11, c: fg)),
      );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;
  const PrimaryButton(this.label, {super.key, this.icon, this.onTap, this.color = C.btn});
  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
    if (icon == null) return ElevatedButton(onPressed: onTap, style: style, child: Text(label));
    return ElevatedButton.icon(onPressed: onTap, style: style, icon: Icon(icon, size: 18), label: Text(label));
  }
}

class OutlineBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;
  const OutlineBtn(this.label, {super.key, this.icon, this.onTap, this.color = C.ink});
  @override
  Widget build(BuildContext context) {
    final style = OutlinedButton.styleFrom(
      foregroundColor: color,
      side: const BorderSide(color: C.border),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
    if (icon == null) return OutlinedButton(onPressed: onTap, style: style, child: Text(label));
    return OutlinedButton.icon(onPressed: onTap, style: style, icon: Icon(icon, size: 18), label: Text(label));
  }
}

OutlineInputBorder _b(Color c) =>
    OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c));

class Field extends StatelessWidget {
  final String label;
  final String? hint, error;
  final TextEditingController? controller;
  final bool obscure, readOnly;
  final TextInputType? type;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? formatters;
  const Field(this.label,
      {super.key,
      this.hint,
      this.error,
      this.controller,
      this.obscure = false,
      this.readOnly = false,
      this.type,
      this.suffix,
      this.onChanged,
      this.onTap,
      this.formatters});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: ts(13, w: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          readOnly: readOnly,
          keyboardType: type,
          onChanged: onChanged,
          onTap: onTap,
          inputFormatters: formatters,
          style: ts(14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: ts(14, c: C.muted),
            errorText: error,
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: _b(C.border),
            enabledBorder: _b(C.border),
            focusedBorder: _b(C.primary),
            errorBorder: _b(C.red),
            focusedErrorBorder: _b(C.red),
          ),
        ),
      ]);
}

class Drop extends StatelessWidget {
  final String label, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? hint;
  const Drop(this.label, this.value, this.items, this.onChanged, {super.key, this.hint});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: ts(13, w: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          hint: hint == null ? null : Text(hint!, style: ts(14, c: C.muted)),
          items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i, style: ts(14)))],
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _b(C.border),
            enabledBorder: _b(C.border),
            focusedBorder: _b(C.primary),
          ),
        ),
      ]);
}

class LinkText extends StatelessWidget {
  final String prefix, link;
  final VoidCallback onTap;
  const LinkText(this.prefix, this.link, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
        Text('$prefix ', style: ts(13, c: C.muted)),
        InkWell(onTap: onTap, child: Text(link, style: ts(13, w: FontWeight.w700, c: C.primary))),
      ]);
}

/// Baris pada layar lebar, kolom pada layar sempit.
class Cols extends StatelessWidget {
  final List<Widget> children;
  final List<int>? flex;
  final double gap, breakpoint;
  const Cols({super.key, required this.children, this.flex, this.gap = 16, this.breakpoint = 700});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_, c) {
        final items = <Widget>[];
        final wide = c.maxWidth >= breakpoint;
        for (var i = 0; i < children.length; i++) {
          if (i > 0) items.add(wide ? SizedBox(width: gap) : SizedBox(height: gap));
          items.add(wide ? Expanded(flex: flex?[i] ?? 1, child: children[i]) : children[i]);
        }
        return wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: items)
            : Column(children: items);
      });
}

class PageHeader extends StatelessWidget {
  final String title, subtitle;
  final Widget? action;
  const PageHeader(this.title, this.subtitle, {super.key, this.action});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: ts(26, w: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(subtitle, style: ts(13, c: C.muted)),
            ]),
          ),
          if (action != null) action!,
        ]),
      );
}

class StatCard extends StatelessWidget {
  final String label, value;
  final Color color;
  const StatCard(this.label, this.value, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Panel(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: ts(12, c: C.muted)),
          const SizedBox(height: 8),
          Text(value, style: ts(24)),
          const SizedBox(height: 10),
          Container(width: 28, height: 3, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        ]),
      );
}

// ───────────────────────── Sidebar & shell ─────────────────────────

Future<void> confirmLogout(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Text('Log out?', style: ts(30, w: FontWeight.w800))),
            const SizedBox(height: 16),
            Text('Sesi Anda akan diakhiri. Jangan lupa kembali lagi untuk terus memantau keuanganmu!', style: ts(16)),
            const SizedBox(height: 28),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              OutlineBtn('Batal', color: C.green, onTap: () => Navigator.pop(ctx)),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE9EC),
                  foregroundColor: C.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                child: const Text('Log out'),
              ),
            ]),
          ]),
        ),
      ),
    ),
  );
}

class Sidebar extends StatelessWidget {
  final String route;
  const Sidebar({super.key, required this.route});

  static const _items = [
    ('/dashboard', 'Dashboard', Icons.grid_view_rounded),
    ('/transaksi', 'Transaksi', Icons.swap_horiz_rounded),
    ('/literasi', 'Literasi', Icons.menu_book_outlined),
    ('/kuis', 'Kuis Keuangan', Icons.show_chart_rounded),
  ];

  void _go(BuildContext c, String r) {
    if (r != route) Navigator.pushReplacementNamed(c, r);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.I,
      builder: (context, _) {
        final s = AppState.I;
        return Container(
          width: 230,
          color: C.navy,
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 8),
              const Align(alignment: Alignment.centerLeft, child: Logo()),
              const SizedBox(height: 24),
              for (final it in _items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: it.$1 == route ? C.primary : C.navyDark,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _go(context, it.$1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(children: [
                          Icon(it.$3, size: 18, color: Colors.white70),
                          const SizedBox(width: 10),
                          Text(it.$2, style: ts(13, c: Colors.white)),
                        ]),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              InkWell(
                onTap: () => _go(context, '/profil'),
                child: Row(children: [
                  CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Text(s.inisial, style: ts(12, w: FontWeight.bold, c: C.primary))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.namaLengkap, overflow: TextOverflow.ellipsis, style: ts(13, w: FontWeight.w600, c: Colors.white)),
                      Text(s.email, overflow: TextOverflow.ellipsis, style: ts(10, c: Colors.white54)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: () => confirmLogout(context),
                child: Row(children: [
                  const Icon(Icons.logout_rounded, color: C.red, size: 18),
                  const SizedBox(width: 8),
                  Text('Logout', style: ts(13, c: C.red)),
                ]),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        );
      },
    );
  }
}

class AppShell extends StatelessWidget {
  final String route;
  final Widget child;
  const AppShell({super.key, required this.route, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, c) {
      final wide = c.maxWidth >= 900;
      final body = SingleChildScrollView(
        padding: EdgeInsets.all(wide ? 32 : 16),
        child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1200), child: child)),
      );
      if (wide) {
        return Scaffold(
          body: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Sidebar(route: route), Expanded(child: body)]),
        );
      }
      return Scaffold(
        appBar: AppBar(backgroundColor: C.navy, foregroundColor: Colors.white, title: const Text('Finova')),
        drawer: Drawer(width: 230, child: Sidebar(route: route)),
        body: body,
      );
    });
  }
}

// ───────────────────────── Painter ─────────────────────────

class DonutPainter extends CustomPainter {
  final List<double> vals;
  final List<Color> colors;
  DonutPainter(this.vals, this.colors);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    final total = vals.fold<double>(0, (a, b) => a + b);
    var start = -pi / 2;
    for (var i = 0; i < vals.length; i++) {
      final sweep = 2 * pi * vals[i] / total;
      canvas.drawArc(rect, start, sweep - 0.03, false,
          Paint()..style = PaintingStyle.stroke..strokeWidth = 20..color = colors[i]);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class RingPainter extends CustomPainter {
  final double p;
  final Color color;
  RingPainter(this.p, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(8, 8, size.width - 16, size.height - 16);
    canvas.drawArc(rect, 0, 2 * pi, false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 16..color = const Color(0xFFE3F3EC));
    canvas.drawArc(rect, -pi / 2, 2 * pi * p, false,
        Paint()..style = PaintingStyle.stroke..strokeWidth = 16..strokeCap = StrokeCap.round..color = color);
  }

  @override
  bool shouldRepaint(covariant RingPainter old) => old.p != p;
}
