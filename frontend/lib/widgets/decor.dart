import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Flowing hand-drawn style lines + a soft wave at the bottom of a hero.
class WaveBackgroundPainter extends CustomPainter {
  const WaveBackgroundPainter({this.fill = Colors.white, this.showLines = true});
  final Color fill;
  final bool showLines;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Soft peach swell on the right.
    final swell = Path()
      ..moveTo(w * 0.52, 0)
      ..cubicTo(w * 0.62, h * 0.18, w * 0.98, h * 0.06, w, h * 0.22)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(swell, Paint()..color = AppColors.peach.withValues(alpha: 0.35));

    if (showLines) {
      final line = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.apricot.withValues(alpha: 0.9);
      final p1 = Path()
        ..moveTo(0, h * 0.62)
        ..cubicTo(w * 0.22, h * 0.48, w * 0.36, h * 0.98, w * 0.6, h * 0.86)
        ..cubicTo(w * 0.78, h * 0.76, w * 0.84, h * 0.2, w, h * 0.12);
      canvas.drawPath(p1, line);
      final p2 = Path()
        ..moveTo(w * 0.42, h * 0.02)
        ..cubicTo(w * 0.56, h * 0.18, w * 0.6, h * 0.42, w * 0.74, h * 0.5)
        ..cubicTo(w * 0.86, h * 0.58, w * 0.92, h * 0.44, w, h * 0.5);
      canvas.drawPath(p2, line..color = AppColors.apricot.withValues(alpha: 0.45));
    }

    // White wave that the next section sits on.
    final wave = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.9)
      ..cubicTo(w * 0.25, h * 0.78, w * 0.45, h * 1.0, w * 0.7, h * 0.9)
      ..cubicTo(w * 0.85, h * 0.84, w * 0.95, h * 0.86, w, h * 0.88)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(wave, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(covariant WaveBackgroundPainter old) => old.fill != fill || old.showLines != showLines;
}

/// Coral brush-stroke underline drawn beneath a highlighted word.
class SquiggleUnderline extends StatelessWidget {
  const SquiggleUnderline({super.key, required this.child, this.color = AppColors.coral});
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter: _SquigglePainter(color),
        child: Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
      );
}

class _SquigglePainter extends CustomPainter {
  const _SquigglePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height - 4;
    final p = Path()
      ..moveTo(2, y)
      ..quadraticBezierTo(size.width * 0.5, y - 9, size.width - 2, y - 1);
    canvas.drawPath(
        p,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.round
          ..color = color);
  }

  @override
  bool shouldRepaint(covariant _SquigglePainter old) => old.color != color;
}

/// Small decorative ring / cross marks scattered around hero art.
class DecoRing extends StatelessWidget {
  const DecoRing({super.key, this.size = 12, this.color = AppColors.coral});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color, width: 2)),
      );
}

class DecoCross extends StatelessWidget {
  const DecoCross({super.key, this.size = 16, this.color = AppColors.muted});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Transform.rotate(
        angle: math.pi / 4,
        child: Icon(Icons.add, size: size, color: color),
      );
}

/// Organic rounded blob clip used for hero photos.
class BlobClipper extends CustomClipper<Path> {
  const BlobClipper();

  @override
  Path getClip(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.82, 0, w, h * 0.2, w, h * 0.5)
      ..cubicTo(w, h * 0.8, w * 0.8, h, w * 0.48, h)
      ..cubicTo(w * 0.18, h, 0, h * 0.78, 0, h * 0.5)
      ..cubicTo(0, h * 0.18, w * 0.2, 0, w * 0.5, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Lifts its child slightly and deepens the shadow on hover.
class HoverLift extends StatefulWidget {
  const HoverLift({super.key, required this.child, this.radius = 18, this.onTap});
  final Widget child;
  final double radius;
  final VoidCallback? onTap;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color: AppColors.mochaDark.withValues(alpha: _hover ? 0.14 : 0.0),
                blurRadius: 34,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// White floating card with an icon bubble, used over photos.
class FloatingBadge extends StatelessWidget {
  const FloatingBadge({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.bubble = AppColors.blush,
    this.iconColor = AppColors.coral,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color bubble;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.12), blurRadius: 30, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(color: bubble, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink)),
          Text(subtitle, style: t.bodySmall?.copyWith(color: AppColors.muted)),
        ]),
      ]),
    );
  }
}
