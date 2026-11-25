import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'decor.dart';

/// Decorative artwork shown on the right of inner-page heroes (no photos).
enum HeroArt { mandala, orbit, seal, hearts, sunrise }

class HeroArtwork extends StatelessWidget {
  const HeroArtwork({super.key, required this.art, this.size = 420});
  final HeroArt art;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: switch (art) {
        HeroArt.mandala => _Mandala(size: size),
        HeroArt.orbit => _Orbit(size: size),
        HeroArt.seal => _Seal(size: size),
        HeroArt.hearts => _Hearts(size: size),
        HeroArt.sunrise => _Sunrise(size: size),
      },
    );
  }
}

/// Very slow continuous rotation; stops when the user prefers reduced motion.
class _Spin extends StatefulWidget {
  const _Spin({required this.child, this.seconds = 90, this.reverse = false});
  final Widget child;
  final int seconds;
  final bool reverse;

  @override
  State<_Spin> createState() => _SpinState();
}

class _SpinState extends State<_Spin> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: Duration(seconds: widget.seconds));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) =>
            Transform.rotate(angle: (widget.reverse ? -1 : 1) * _c.value * 2 * math.pi, child: child),
        child: widget.child,
      );
}

Widget _iconBubble(IconData icon, double d, {Color bg = Colors.white, Color fg = AppColors.coral}) => Container(
      width: d,
      height: d,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Icon(icon, color: fg, size: d * 0.46),
    );

// ───────────── About: lotus mandala ─────────────

class _Mandala extends StatelessWidget {
  const _Mandala({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      _Spin(child: CustomPaint(size: Size.square(size), painter: const _MandalaPainter())),
      Container(
        width: size * 0.3,
        height: size * 0.3,
        decoration: BoxDecoration(
          color: AppColors.coral,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.peach.withValues(alpha: 0.6), width: 6),
          boxShadow: [BoxShadow(color: AppColors.coral.withValues(alpha: 0.45), blurRadius: 40)],
        ),
        child: Icon(Icons.spa_outlined, color: Colors.white, size: size * 0.13),
      ),
    ]);
  }
}

class _MandalaPainter extends CustomPainter {
  const _MandalaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Concentric rings.
    for (final (f, a) in const [(0.98, 0.18), (0.8, 0.3), (0.62, 0.22)]) {
      canvas.drawCircle(c, r * f, stroke..color = AppColors.apricot.withValues(alpha: a));
    }
    // Dotted ring.
    final dot = Paint()..color = AppColors.apricot.withValues(alpha: 0.55);
    for (var i = 0; i < 48; i++) {
      final a = i * 2 * math.pi / 48;
      canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * r * 0.89, 2, dot);
    }
    // Outer petals.
    _petals(canvas, c,
        count: 12,
        dist: r * 0.5,
        len: r * 0.26,
        width: r * 0.11,
        fill: AppColors.peach.withValues(alpha: 0.10),
        line: AppColors.apricot.withValues(alpha: 0.55));
    // Inner petals, offset.
    _petals(canvas, c,
        count: 8,
        dist: r * 0.3,
        len: r * 0.17,
        width: r * 0.09,
        offset: math.pi / 8,
        fill: AppColors.coral.withValues(alpha: 0.18),
        line: AppColors.coral.withValues(alpha: 0.6));
  }

  void _petals(Canvas canvas, Offset c,
      {required int count,
      required double dist,
      required double len,
      required double width,
      required Color fill,
      required Color line,
      double offset = 0}) {
    for (var i = 0; i < count; i++) {
      final a = offset + i * 2 * math.pi / count;
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(a);
      final rect = Rect.fromCenter(center: Offset(dist, 0), width: len * 2, height: width * 2);
      canvas.drawOval(rect, Paint()..color = fill);
      canvas.drawOval(
          rect,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.3
            ..color = line);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────── Our Work: orbit of programme icons ─────────────

class _Orbit extends StatelessWidget {
  const _Orbit({required this.size});
  final double size;

  static const _icons = [
    Icons.spa_outlined,
    Icons.self_improvement,
    Icons.eco_outlined,
    Icons.healing_outlined,
    Icons.elderly,
    Icons.child_care,
    Icons.school_outlined,
    Icons.park_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final r = size / 2;
    final bubble = size * 0.15;
    return Stack(alignment: Alignment.center, children: [
      CustomPaint(size: Size.square(size), painter: const _OrbitRingsPainter()),
      // Outer ring of icons rotates slowly; each icon counter-rotates to stay upright.
      _Spin(
        seconds: 120,
        child: SizedBox.square(
          dimension: size,
          child: Stack(children: [
            for (var i = 0; i < _icons.length; i++)
              Positioned(
                left: r + math.cos(i * 2 * math.pi / _icons.length) * r * 0.8 - bubble / 2,
                top: r + math.sin(i * 2 * math.pi / _icons.length) * r * 0.8 - bubble / 2,
                child: _Spin(
                  seconds: 120,
                  reverse: true,
                  child: _iconBubble(_icons[i], bubble,
                      bg: i.isEven ? Colors.white : AppColors.peach,
                      fg: i.isEven ? AppColors.coral : AppColors.mochaDark),
                ),
              ),
          ]),
        ),
      ),
      Container(
        width: size * 0.34,
        height: size * 0.34,
        decoration: BoxDecoration(
          color: AppColors.coral,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: AppColors.coral.withValues(alpha: 0.45), blurRadius: 40)],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('8',
              style: TextStyle(color: Colors.white, fontSize: size * 0.11, fontWeight: FontWeight.w700, height: 1)),
          const SizedBox(height: 4),
          Text('PROGRAMMES',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: size * 0.026,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    ]);
  }
}

class _OrbitRingsPainter extends CustomPainter {
  const _OrbitRingsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(c, r * 0.8, p..color = AppColors.apricot.withValues(alpha: 0.45));
    canvas.drawCircle(c, r * 0.5, p..color = AppColors.apricot.withValues(alpha: 0.25));
    // Dashed inner ring.
    for (var i = 0; i < 60; i += 2) {
      final a1 = i * 2 * math.pi / 60, a2 = (i + 1) * 2 * math.pi / 60;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r * 0.64), a1, a2 - a1, false,
          p..color = AppColors.apricot.withValues(alpha: 0.35));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────── VKN USA: certification seal ─────────────

class _Seal extends StatelessWidget {
  const _Seal({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      _Spin(seconds: 70, child: CustomPaint(size: Size.square(size * 0.86), painter: const _SealTextPainter())),
      CustomPaint(size: Size.square(size * 0.62), painter: const _ScallopPainter()),
      Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified, color: Colors.white, size: size * 0.11),
        const SizedBox(height: 6),
        Text('501(c)(3)',
            style: TextStyle(color: Colors.white, fontSize: size * 0.075, fontWeight: FontWeight.w700, height: 1.1)),
        const SizedBox(height: 4),
        Text('PUBLIC CHARITY',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: size * 0.027,
                letterSpacing: 2.4,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text('Since 2024', style: TextStyle(color: AppColors.peach, fontSize: size * 0.032)),
      ]),
      // Small stars around the seal.
      for (final (dx, dy, s) in const [(0.06, 0.12, 0.05), (0.9, 0.2, 0.04), (0.84, 0.86, 0.055), (0.1, 0.8, 0.035)])
        Positioned(
          left: size * dx,
          top: size * dy,
          child: Icon(Icons.star_rounded, color: AppColors.apricot.withValues(alpha: 0.7), size: size * s),
        ),
    ]);
  }
}

class _ScallopPainter extends CustomPainter {
  const _ScallopPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    const n = 24;
    final path = Path();
    for (var i = 0; i <= n * 2; i++) {
      final a = i * math.pi / n;
      final rr = i.isEven ? r : r * 0.92;
      final pt = c + Offset(math.cos(a), math.sin(a)) * rr;
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawShadow(path, Colors.black, 12, false);
    canvas.drawPath(path, Paint()..color = AppColors.coral);
    canvas.drawCircle(
        c,
        r * 0.8,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.55));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Text running around a circle: "VKN CHARITIES INC. • LOUISVILLE, KENTUCKY •".
class _SealTextPainter extends CustomPainter {
  const _SealTextPainter();

  static const _text = 'VKN CHARITIES INC.  •  LOUISVILLE, KENTUCKY  •  EIN 87-3637206  •  ';

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 12;
    canvas.drawCircle(
        c,
        r + 14,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = AppColors.apricot.withValues(alpha: 0.35));
    const step = 2 * math.pi / _text.length;
    for (var i = 0; i < _text.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: _text[i],
          style: TextStyle(
              color: AppColors.apricot.withValues(alpha: 0.85),
              fontSize: size.width * 0.034,
              fontWeight: FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final a = -math.pi / 2 + i * step;
      canvas.save();
      canvas.translate(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
      canvas.rotate(a + math.pi / 2);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────── Get Involved: floating help bubbles ─────────────

class _Hearts extends StatelessWidget {
  const _Hearts({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget card(IconData icon, String label, Color bg, Color fg) => Container(
          padding: EdgeInsets.fromLTRB(size * 0.025, size * 0.025, size * 0.05, size * 0.025),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.22), blurRadius: 24, offset: const Offset(0, 10))
            ],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: size * 0.11,
              height: size * 0.11,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: fg, size: size * 0.055),
            ),
            SizedBox(width: size * 0.025),
            Text(label, style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: size * 0.036)),
          ]),
        );

    return Stack(clipBehavior: Clip.none, children: [
      // Big soft heart in the middle.
      Positioned.fill(
        child: Center(
          child: Container(
            width: size * 0.56,
            height: size * 0.56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColors.coral.withValues(alpha: 0.5),
                AppColors.coral.withValues(alpha: 0.0),
              ]),
            ),
            child: Icon(Icons.favorite_rounded, color: AppColors.coral, size: size * 0.3),
          ),
        ),
      ),
      CustomPaint(size: Size.square(size), painter: const _LoopsPainter()),
      Positioned(
          left: size * 0.02,
          top: size * 0.12,
          child: card(Icons.volunteer_activism_outlined, 'Donate', AppColors.blush, AppColors.coral)),
      Positioned(
          right: 0,
          top: size * 0.36,
          child: card(Icons.groups_outlined, 'Volunteer', AppColors.lilac, const Color(0xFF8E5FB0))),
      Positioned(
          left: size * 0.08,
          bottom: size * 0.12,
          child: card(Icons.mail_outline, 'Say hello', AppColors.mist, const Color(0xFF3F8A99))),
      Positioned(
          right: size * 0.16,
          top: size * 0.06,
          child: Icon(Icons.favorite, color: AppColors.peach.withValues(alpha: 0.7), size: size * 0.06)),
      Positioned(
          right: size * 0.1,
          bottom: size * 0.16,
          child: Icon(Icons.favorite, color: AppColors.apricot.withValues(alpha: 0.6), size: size * 0.045)),
      Positioned(
          left: size * 0.4,
          bottom: size * 0.02,
          child: Icon(Icons.favorite, color: AppColors.coral.withValues(alpha: 0.7), size: size * 0.04)),
    ]);
  }
}

/// Dashed looping path connecting the help bubbles.
class _LoopsPainter extends CustomPainter {
  const _LoopsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.2, h * 0.22)
      ..cubicTo(w * 0.7, h * 0.0, w * 1.0, h * 0.3, w * 0.75, h * 0.45)
      ..cubicTo(w * 0.5, h * 0.6, w * 0.1, h * 0.55, w * 0.25, h * 0.8);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = AppColors.apricot.withValues(alpha: 0.55);
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 14) {
        canvas.drawPath(m.extractPath(d, d + 7), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────── Home: lotus sunrise ─────────────

class _Sunrise extends StatelessWidget {
  const _Sunrise({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final small = size < 420;
    return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
      _Spin(seconds: 140, child: CustomPaint(size: Size.square(size), painter: const _SunburstPainter())),
      // Peach halo ring.
      Container(
        width: size * 0.62,
        height: size * 0.62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.peach.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.peach.withValues(alpha: 0.35), width: 1.5),
        ),
      ),
      // Circular photo.
      Container(
        width: size * 0.5,
        height: size * 0.5,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 6),
          boxShadow: [BoxShadow(color: AppColors.coral.withValues(alpha: 0.45), blurRadius: 50)],
        ),
        child: ClipOval(child: Image.asset('assets/images/hero-meditation.jpg', fit: BoxFit.cover)),
      ),
      // Small coral lotus badge on the photo edge.
      Positioned(
        left: size * 0.5 + size * 0.25 * 0.707 - size * 0.06,
        top: size * 0.5 + size * 0.25 * 0.707 - size * 0.06,
        child: Container(
          width: size * 0.12,
          height: size * 0.12,
          decoration: BoxDecoration(
            color: AppColors.coral,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 14, offset: const Offset(0, 6))
            ],
          ),
          child: Icon(Icons.spa_outlined, color: Colors.white, size: size * 0.055),
        ),
      ),
      Positioned(
        left: small ? -10 : null,
        right: small ? null : -20,
        top: small ? -size * 0.02 : size * 0.06,
        child: const FloatingBadge(
          icon: Icons.volunteer_activism_outlined,
          title: '8 Focus Areas',
          subtitle: 'Healing, care & education',
        ),
      ),
      if (!small)
        Positioned(
          left: -size * 0.16,
          top: size * 0.52,
          child: const FloatingBadge(
            icon: Icons.self_improvement,
            title: 'Since 2020',
            subtitle: 'Serving Tamil Nadu',
            bubble: AppColors.lilac,
            iconColor: Color(0xFF8E5FB0),
          ),
        ),
      Positioned(
        right: small ? -10 : size * 0.06,
        bottom: small ? -size * 0.02 : size * 0.04,
        child: const FloatingBadge(
          icon: Icons.public,
          title: 'India & USA',
          subtitle: '12A · 80G · 501(c)(3)',
          bubble: AppColors.mist,
          iconColor: Color(0xFF3F8A99),
        ),
      ),
    ]);
  }
}

class _SunburstPainter extends CustomPainter {
  const _SunburstPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    final ray = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    const n = 48;
    for (var i = 0; i < n; i++) {
      final a = i * 2 * math.pi / n;
      final dir = Offset(math.cos(a), math.sin(a));
      final long = i.isEven;
      canvas.drawLine(c + dir * r * 0.3, c + dir * r * (long ? 0.92 : 0.7),
          ray..color = AppColors.apricot.withValues(alpha: long ? 0.28 : 0.16));
      if (long) canvas.drawCircle(c + dir * r * 0.96, 2.4, Paint()..color = AppColors.apricot.withValues(alpha: 0.55));
    }
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    canvas.drawCircle(c, r * 0.8, ring..color = AppColors.apricot.withValues(alpha: 0.22));
    canvas.drawCircle(c, r * 0.62, ring..color = AppColors.apricot.withValues(alpha: 0.3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
