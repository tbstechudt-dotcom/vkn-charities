import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import 'decor.dart';
import 'footer.dart';
import 'hero_art.dart';

export 'hero_art.dart' show HeroArt;

/// Breakpoint helpers.
bool isMobile(BuildContext c) => MediaQuery.sizeOf(c).width < 760;
bool isDesktop(BuildContext c) => MediaQuery.sizeOf(c).width >= 1080;

/// Header collapses to a menu button below this width (full nav needs ~950px).
bool useCompactNav(BuildContext c) => MediaQuery.sizeOf(c).width < 1000;

/// Scrollable page body that always ends with the site footer.
class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...children, const SiteFooter()],
      ),
    );
  }
}

/// A full-width band with centred, max-width content.
class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.color, this.vertical, this.maxWidth = 1160});
  final Widget child;
  final Color? color;
  final double? vertical;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 20 : 40,
        vertical: vertical ?? (mobile ? 56 : 88),
      ),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Small coral label above headings.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = AppColors.coral});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
          fontSize: 14.5,
        ),
      );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = false,
    this.light = false,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool center;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final align = center ? TextAlign.center : TextAlign.start;
    final titleStyle = (isMobile(context) ? t.displaySmall?.copyWith(fontSize: 27) : t.displaySmall)
        ?.copyWith(color: light ? Colors.white : AppColors.ink);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: center ? 640 : 720),
      child: Column(
        crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Eyebrow(eyebrow, color: light ? const Color(0xFFFFE2D4) : AppColors.coral),
          const SizedBox(height: 12),
          Text(title, textAlign: align, style: titleStyle),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            Text(subtitle!,
                textAlign: align,
                style: t.bodyLarge?.copyWith(color: light ? Colors.white.withValues(alpha: 0.85) : null)),
          ],
        ],
      ),
    );
  }
}

/// Hero band used at the top of inner pages.
class PageHero extends StatelessWidget {
  const PageHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.art,
    required this.crumb,
    this.highlights = const [],
  });

  final String eyebrow;
  final String title;
  final String subtitle;

  /// Decorative artwork on the right (different per page).
  final HeroArt art;

  /// Current page name for the breadcrumb ("Home › About Us").
  final String crumb;

  /// Small glass chips under the subtitle: (icon, label).
  final List<(IconData, String)> highlights;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final mobile = isMobile(context);
    final desktop = isDesktop(context);

    final crumbs = Row(mainAxisSize: MainAxisSize.min, children: [
      InkWell(
        onTap: () => context.go('/'),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.home_outlined, size: 16, color: Colors.white70),
          SizedBox(width: 6),
          Text('Home', style: TextStyle(color: Colors.white70, fontSize: 13)),
        ]),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Icon(Icons.chevron_right, size: 16, color: Colors.white38),
      ),
      Text(crumb, style: const TextStyle(color: AppColors.apricot, fontSize: 13, fontWeight: FontWeight.w600)),
    ]);

    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        crumbs,
        SizedBox(height: mobile ? 26 : 34),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 28, height: 2, color: AppColors.coral),
          const SizedBox(width: 10),
          Flexible(
            child: Text(eyebrow.toUpperCase(),
                style: const TextStyle(
                    color: AppColors.apricot, fontSize: 12.5, fontWeight: FontWeight.w600, letterSpacing: 2.2)),
          ),
        ]),
        const SizedBox(height: 14),
        Text(title,
            style: (mobile ? t.displaySmall?.copyWith(fontSize: 31) : t.displayMedium)
                ?.copyWith(color: Colors.white, height: 1.15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
        Text(subtitle, style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
        if (highlights.isNotEmpty) ...[
          SizedBox(height: mobile ? 24 : 32),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final h in highlights)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(h.$1, size: 16, color: AppColors.apricot),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(h.$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
          ]),
        ],
      ]),
    );

    return HeroBackdrop(
      behind: desktop
          ? null
          // On phones/tablets the artwork sits faintly behind the text.
          : Positioned(
              right: mobile ? -110 : -40,
              top: mobile ? 10 : 30,
              child: Opacity(
                  opacity: mobile ? 0.1 : 0.16,
                  child: IgnorePointer(child: HeroArtwork(art: art, size: mobile ? 300 : 360))),
            ),
      child: Section(
        vertical: 0,
        child: Padding(
          padding: EdgeInsets.only(top: mobile ? 36 : 56, bottom: mobile ? 76 : 110),
          child: desktop
              ? Row(children: [
                  Expanded(child: content),
                  const SizedBox(width: 40),
                  HeroArtwork(art: art, size: 400),
                ])
              : Align(alignment: Alignment.centerLeft, child: content),
        ),
      ),
    );
  }
}

/// Shared hero background: brown gradient, dot texture, glows and a curved white bottom edge.
class HeroBackdrop extends StatelessWidget {
  const HeroBackdrop({super.key, required this.child, this.behind});
  final Widget child;

  /// Optional positioned decoration painted under [child].
  final Widget? behind;

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final desktop = isDesktop(context);
    return Stack(children: [
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.espresso, AppColors.mochaDark, Color(0xFF8A5A48)],
              stops: [0, 0.6, 1],
            ),
          ),
        ),
      ),
      const Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
      Positioned(right: desktop ? 60 : -120, top: -80, child: _glow(desktop ? 520 : 360, AppColors.coral, 0.22)),
      Positioned(left: -160, bottom: -200, child: _glow(420, AppColors.apricot, 0.12)),
      if (!mobile) ...const [
        Positioned(left: 40, top: 70, child: DecoRing(size: 12, color: AppColors.apricot)),
        Positioned(left: 44, bottom: 130, child: DecoCross(color: Colors.white38)),
      ],
      if (behind != null) behind!,
      child,
      Positioned(
        left: 0,
        right: 0,
        bottom: -1,
        height: mobile ? 36 : 60,
        child: const CustomPaint(painter: _HeroEdgePainter()),
      ),
    ]);
  }
}

Widget _glow(double d, Color c, double a) => IgnorePointer(
      child: Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [c.withValues(alpha: a), c.withValues(alpha: 0)]),
        ),
      ),
    );

/// Subtle dot grid texture for hero backgrounds.
class _DotGridPainter extends CustomPainter {
  const _DotGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.06);
    const gap = 26.0;
    for (var y = gap / 2; y < size.height; y += gap) {
      for (var x = gap / 2; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), 1.2, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroEdgePainter extends CustomPainter {
  const _HeroEdgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.55)
      ..cubicTo(w * 0.3, h * 1.05, w * 0.65, -h * 0.1, w, h * 0.4)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Lays children out in 1 / [tablet] / [desktop] columns depending on width.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.desktop = 3,
    this.tablet = 2,
    this.spacing = 24,
  });

  final List<Widget> children;
  final int desktop;
  final int tablet;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final cols = c.maxWidth >= 960 ? desktop : (c.maxWidth >= 600 ? tablet : 1);
      final w = (c.maxWidth - spacing * (cols - 1)) / cols;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [for (final child in children) SizedBox(width: w, child: child)],
      );
    });
  }
}

/// Pastel bubble colour picked from a stable key, so cards vary gently.
(Color, Color) bubbleFor(String key) {
  const options = [
    (AppColors.blush, AppColors.coral),
    (AppColors.lilac, Color(0xFF8E5FB0)),
    (AppColors.mist, Color(0xFF3F8A99)),
    (Color(0xFFFFF0D9), Color(0xFFC98A2E)),
  ];
  return options[key.codeUnits.fold<int>(0, (a, b) => a + b) % options.length];
}

/// Soft card with an icon bubble, title and text. Lifts on hover.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.tag,
    this.minHeight = 0,
    this.center = false,
  });

  final IconData icon;
  final String title;
  final String text;
  final String? tag;
  final double minHeight;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final (bg, fg) = bubbleFor(title);
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    return HoverLift(
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.shell,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: align,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: fg, size: 28),
            ),
            const SizedBox(height: 22),
            Text(title, textAlign: textAlign, style: t.headlineSmall),
            if (tag != null) ...[
              const SizedBox(height: 6),
              Text(tag!,
                  textAlign: textAlign,
                  style: t.labelMedium?.copyWith(color: AppColors.coral, fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 10),
            Text(text, textAlign: textAlign, style: t.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Big number / label tile.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.value, required this.label, this.dark = false});
  final String value;
  final String label;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 26),
      decoration: BoxDecoration(
        color: dark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dark ? Colors.white24 : AppColors.line),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                    color: AppColors.mochaDark.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, 10))
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: t.headlineMedium?.copyWith(color: dark ? const Color(0xFFFFE2D4) : AppColors.mocha)),
          const SizedBox(height: 6),
          Text(label, style: t.bodyMedium?.copyWith(color: dark ? Colors.white70 : AppColors.muted)),
        ],
      ),
    );
  }
}

/// Brown call-to-action band with a photo.
class CtaBand extends StatelessWidget {
  const CtaBand({super.key, required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final mobile = isMobile(context);
    final desktop = isDesktop(context);

    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Eyebrow('Make a difference', color: Color(0xFFFFE2D4)),
        const SizedBox(height: 12),
        Text(title, style: (mobile ? t.headlineMedium : t.displaySmall)?.copyWith(color: Colors.white)),
        const SizedBox(height: 14),
        Text(text, style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.88))),
        const SizedBox(height: 28),
        Wrap(spacing: 12, runSpacing: 12, children: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.mochaDark),
            onPressed: () => context.go('/get-involved'),
            child: const Text('Donate Now'),
          ),
          OutlinedButton(
            style:
                OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
            onPressed: () => context.go('/get-involved?tab=volunteer'),
            child: const Text('Become a Volunteer'),
          ),
        ]),
      ],
    );

    final photo = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset('assets/images/elder_hands.jpg', fit: BoxFit.cover, height: 300),
    );

    return Section(
      vertical: mobile ? 48 : 80,
      child: Container(
        padding: EdgeInsets.all(mobile ? 28 : 52),
        decoration: BoxDecoration(
          color: AppColors.band,
          borderRadius: BorderRadius.circular(28),
        ),
        child: desktop
            ? Row(children: [
                Expanded(flex: 6, child: copy),
                const SizedBox(width: 48),
                Expanded(flex: 4, child: photo),
              ])
            : copy,
      ),
    );
  }
}

/// Simple tick row.
class Bullet extends StatelessWidget {
  const Bullet(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 14, color: AppColors.coral),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ]),
      );
}

/// Checklist card like "✓ Title / text" on a soft background.
class CheckCard extends StatelessWidget {
  const CheckCard({super.key, required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: AppColors.shell, borderRadius: BorderRadius.circular(14)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 15, color: AppColors.coral),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: t.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: AppColors.ink)),
            const SizedBox(height: 6),
            Text(text, style: t.bodyMedium),
          ]),
        ),
      ]),
    );
  }
}
