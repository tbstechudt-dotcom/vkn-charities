import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/decor.dart';
import '../widgets/hero_art.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageBody(children: [
      _Hero(),
      _FocusAreas(),
      _About(),
      _ProgramsBand(),
      _Impact(),
      _CareStories(),
      _GlobalPresence(),
      CtaBand(
        title: 'Every act of kindness heals someone.',
        text: 'Your support brings care to orphaned elders and children, and holistic healing to those who need it.',
      ),
    ]);
  }
}

// ───────────────────────────── Hero ─────────────────────────────

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final mobile = isMobile(context);
    final desktop = isDesktop(context);
    final h1 = (mobile ? t.displaySmall?.copyWith(fontSize: 36) : t.displayLarge)
        ?.copyWith(fontWeight: FontWeight.w600, height: 1.15, color: Colors.white);

    Widget trust(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 17, color: AppColors.apricot),
          const SizedBox(width: 8),
          Flexible(
            child: Text(text,
                style:
                    TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ]);

    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.spa_outlined, size: 15, color: AppColors.apricot),
          SizedBox(width: 8),
          Flexible(
            child: Text('WELCOME TO VKN CHARITIES',
                style:
                    TextStyle(color: AppColors.apricot, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 2)),
          ),
        ]),
      ),
      const SizedBox(height: 22),
      Text('Healing Body, Mind', style: h1),
      Wrap(crossAxisAlignment: WrapCrossAlignment.end, children: [
        Text('& ', style: h1),
        SquiggleUnderline(child: Text('Spirit.', style: h1?.copyWith(color: AppColors.peach))),
      ]),
      const SizedBox(height: 22),
      ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Text(
          'Yoga, meditation, Ayurveda, Siddha and natural therapies for the community, '
          'and loving care for orphaned elders and children across Tamil Nadu.',
          style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
        ),
      ),
      const SizedBox(height: 34),
      Wrap(spacing: 14, runSpacing: 14, children: [
        FilledButton(
          onPressed: () => context.go('/get-involved'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 19),
          ),
          child: const Text('Support Our Work'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go('/programs'),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Explore Programmes'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white54),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 19),
          ),
        ),
      ]),
      SizedBox(height: mobile ? 30 : 42),
      Container(height: 1, width: 520, color: Colors.white.withValues(alpha: 0.14)),
      const SizedBox(height: 20),
      Wrap(spacing: 26, runSpacing: 12, children: [
        trust(Icons.verified_outlined, '12A & 80G registered'),
        trust(Icons.public, '501(c)(3) in the USA'),
        trust(Icons.favorite_border, 'Founded by Dr. Krishna Nadar'),
      ]),
    ]);

    return HeroBackdrop(
      child: Section(
        vertical: 0,
        child: Padding(
          padding: EdgeInsets.only(top: mobile ? 40 : 64, bottom: mobile ? 80 : 130),
          child: desktop
              ? Row(children: [
                  Expanded(flex: 11, child: text),
                  const SizedBox(width: 48),
                  const Expanded(flex: 9, child: Center(child: HeroArtwork(art: HeroArt.sunrise, size: 470))),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  text,
                  const SizedBox(height: 56),
                  LayoutBuilder(
                    builder: (context, c) => Center(
                      child: HeroArtwork(art: HeroArt.sunrise, size: math.min(c.maxWidth - 24, 400)),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}

// ─────────────────────────── Focus areas ───────────────────────────

class _FocusAreas extends StatelessWidget {
  const _FocusAreas();

  @override
  Widget build(BuildContext context) {
    final items = [
      fallbackPrograms.firstWhere((p) => p.slug == 'yoga-meditation'),
      fallbackPrograms.firstWhere((p) => p.slug == 'elder-care'),
      fallbackPrograms.firstWhere((p) => p.slug == 'children'),
    ];
    return Section(
      vertical: isMobile(context) ? 40 : 56,
      child: Column(children: [
        const SectionHeading(
          center: true,
          eyebrow: 'What We Do',
          title: 'A Joyful Investment in Body, Mind & Community',
          subtitle: 'From ancient healing traditions to a safe home for those without family, '
              'our work touches health, wellbeing and dignity.',
        ),
        const SizedBox(height: 52),
        ResponsiveGrid(children: [
          for (final p in items)
            InfoCard(
                icon: iconFor(p.icon),
                title: p.title,
                text: p.summary,
                center: true,
                minHeight: isMobile(context) ? 0 : 300),
        ]),
      ]),
    );
  }
}

// ───────────────────────────── About ─────────────────────────────

class _About extends StatelessWidget {
  const _About();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);
    final mobile = isMobile(context);

    const art = _PhotoMosaic();

    final copy = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Eyebrow('About Us'),
      const SizedBox(height: 12),
      Text("We're Here to Help People Heal, Grow & Find Belonging",
          style: (mobile ? t.headlineMedium : t.displaySmall)?.copyWith(height: 1.3)),
      const SizedBox(height: 16),
      Text(
        'VKN Charities was founded in Coimbatore by Dr. Krishna Nadar. We believe wellbeing is physical, '
        'mental and spiritual, and that no elder or child should be left without care.',
        style: t.bodyLarge,
      ),
      const SizedBox(height: 28),
      const CheckCard(
        title: 'Holistic healing for body, mind & spirit',
        text: 'Yoga, meditation, breathwork, Ayurveda, Siddha and natural therapies for everyone.',
      ),
      const SizedBox(height: 16),
      const CheckCard(
        title: 'Loving care for those who have no one',
        text: 'Shelter, nutrition, health support and companionship for orphaned elders and children.',
      ),
      const SizedBox(height: 30),
      FilledButton(onPressed: () => context.go('/about'), child: const Text('Read Our Story')),
    ]);

    return Section(
      child: desktop
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(child: art),
              const SizedBox(width: 64),
              Expanded(child: copy),
            ])
          : Column(children: [art, const SizedBox(height: 48), copy]),
    );
  }
}

// ─────────────────────────── Programmes band ───────────────────────────

const _programImages = {
  'holistic-healing': 'assets/images/healing.jpg',
  'yoga-meditation': 'assets/images/retreat.jpg',
  'ayurveda-siddha': 'assets/images/ayurveda.jpg',
  'alternative-therapies': 'assets/images/therapy.jpg',
};

class _ProgramsBand extends StatelessWidget {
  const _ProgramsBand();

  @override
  Widget build(BuildContext context) {
    final items = [for (final slug in _programImages.keys) fallbackPrograms.firstWhere((p) => p.slug == slug)];
    return Container(
      color: AppColors.band,
      child: Section(
        color: Colors.transparent,
        child: Column(children: [
          const SectionHeading(
            center: true,
            light: true,
            eyebrow: 'Our Programmes',
            title: 'Healing Programmes for Every Life',
            subtitle: 'Time-tested Indian traditions combined with compassionate, practical care.',
          ),
          const SizedBox(height: 52),
          ResponsiveGrid(desktop: 4, tablet: 2, children: [
            for (final p in items) _ProgramCard(program: p, image: _programImages[p.slug]!),
          ]),
          const SizedBox(height: 44),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.mochaDark),
            onPressed: () => context.go('/programs'),
            child: const Text('View All Our Work'),
          ),
        ]),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.program, required this.image});
  final Program program;
  final String image;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HoverLift(
      onTap: () => context.go('/programs'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          color: Colors.white,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Image.asset(image, height: 200, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(program.category.toUpperCase(),
                    style: t.labelSmall
                        ?.copyWith(color: AppColors.coral, letterSpacing: 1.4, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 46,
                  child:
                      Text(program.title, maxLines: 2, style: t.headlineSmall?.copyWith(fontSize: 17.5, height: 1.3)),
                ),
                const SizedBox(height: 8),
                Text(program.summary, maxLines: 3, overflow: TextOverflow.ellipsis, style: t.bodyMedium),
                const SizedBox(height: 14),
                Row(children: [
                  const Icon(Icons.place_outlined, size: 16, color: AppColors.muted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(program.location ?? '', style: t.bodySmall?.copyWith(color: AppColors.muted)),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────── About mosaic ───────────────────────────

/// 2×2 mosaic: three rounded photos and one coral highlight tile.
class _PhotoMosaic extends StatelessWidget {
  const _PhotoMosaic();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final gap = mobile ? 12.0 : 18.0;

    Widget photo(String img, double h, {BorderRadius? radius}) => ClipRRect(
          borderRadius: radius ?? BorderRadius.circular(22),
          child: Image.asset(img, height: h, width: double.infinity, fit: BoxFit.cover),
        );

    final tile = Container(
      constraints: BoxConstraints(minHeight: mobile ? 150 : 200),
      padding: EdgeInsets.all(mobile ? 18 : 26),
      decoration: BoxDecoration(
        color: AppColors.coral,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: AppColors.coral.withValues(alpha: 0.3), blurRadius: 26, offset: const Offset(0, 12))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: const Icon(Icons.favorite_border, color: Colors.white, size: 22),
        ),
        SizedBox(height: mobile ? 22 : 44),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Founded with compassion',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: mobile ? 14.5 : 17)),
          const SizedBox(height: 4),
          Text('by Dr. Krishna Nadar',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: mobile ? 12 : 13.5)),
        ]),
      ]),
    );

    return Stack(clipBehavior: Clip.none, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(children: [
            photo('assets/images/meditation.jpg', mobile ? 210 : 300,
                radius: const BorderRadius.only(
                    topLeft: Radius.circular(120),
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22))),
            SizedBox(height: gap),
            tile,
          ]),
        ),
        SizedBox(width: gap),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: mobile ? 30 : 48),
            child: Column(children: [
              photo('assets/images/healing.jpg', mobile ? 150 : 200),
              SizedBox(height: gap),
              photo('assets/images/elders.jpg', mobile ? 210 : 300,
                  radius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(120))),
            ]),
          ),
        ),
      ]),
      const Positioned(right: 6, top: 4, child: DecoCross(color: Color(0xFF5DBB9B), size: 20)),
      const Positioned(left: -8, bottom: 40, child: DecoRing(size: 14)),
    ]);
  }
}

// ───────────────────────────── Impact ─────────────────────────────

class _Impact extends StatelessWidget {
  const _Impact();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);
    const stats = [
      (Icons.event_available_outlined, '2020', 'Serving the community since'),
      (Icons.verified_outlined, '12A & 80G', 'Registered under the Income Tax Act'),
      (Icons.public, '2', 'Countries — India & the USA'),
      (Icons.spa_outlined, '8', 'Focus areas of healing & care'),
    ];

    Widget stat((IconData, String, String) s) {
      final (bg, fg) = bubbleFor(s.$3);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(s.$1, color: fg, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(s.$2, style: t.headlineMedium?.copyWith(color: AppColors.mochaDark, fontWeight: FontWeight.w700)),
              Text(s.$3, style: t.bodySmall?.copyWith(color: AppColors.muted)),
            ]),
          ),
        ]),
      );
    }

    final card = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: desktop ? 30 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.08), blurRadius: 40, offset: const Offset(0, 18)),
        ],
      ),
      child: desktop
          ? IntrinsicHeight(
              child: Row(children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0) const VerticalDivider(width: 1, color: AppColors.line),
                  Expanded(child: stat(stats[i])),
                ],
              ]),
            )
          : ResponsiveGrid(spacing: 8, children: [for (final s in stats) stat(s)]),
    );

    // Pulled up so it overlaps the programmes band above.
    return Container(
      color: AppColors.shell,
      child: Transform.translate(
        offset: Offset(0, desktop ? -56 : -36),
        child: Section(vertical: 0, child: card),
      ),
    );
  }
}

// ─────────────────────────── Care stories ───────────────────────────

class _CareStories extends StatelessWidget {
  const _CareStories();

  @override
  Widget build(BuildContext context) {
    return Section(
      color: AppColors.shell,
      vertical: isMobile(context) ? 32 : 40,
      child: Padding(
        padding: EdgeInsets.only(bottom: isMobile(context) ? 24 : 48),
        child: Column(children: [
          const SectionHeading(
            center: true,
            eyebrow: 'Community Service',
            title: 'Nourishing the Hungry, Caring for Young Health',
            subtitle:
                'Two ways we reach out to the community: sacred food donation and free medical camps for students.',
          ),
          const SizedBox(height: 48),
          ResponsiveGrid(desktop: 2, tablet: 2, children: [
            _PhotoStory(
              // Add a real photo at this path and it will replace the illustration automatically.
              image: 'assets/images/annadhanam.jpg',
              tag: 'Annadhanam',
              icon: Icons.soup_kitchen_outlined,
              title: 'Annadhanam — Food Donation',
              text:
                  'Free, nutritious meals served with love to those in need, continuing the sacred tradition of feeding the hungry.',
              gradient: const [Color(0xFFF0B98A), Color(0xFFE9765A), Color(0xFFB4533D)],
              pattern: const [
                Icons.ramen_dining_outlined,
                Icons.soup_kitchen_outlined,
                Icons.restaurant_outlined,
                Icons.volunteer_activism_outlined
              ],
              onTap: () => context.go('/get-involved'),
            ),
            _PhotoStory(
              image: 'assets/images/medical-camp.jpg',
              tag: 'Medical camps',
              icon: Icons.medical_services_outlined,
              title: 'Medical Camps in High Schools',
              text: 'Free health check-ups, screenings and health awareness sessions for high school students.',
              gradient: const [Color(0xFF7FC3CF), Color(0xFF3F8A99), Color(0xFF285E6B)],
              pattern: const [
                Icons.medical_services_outlined,
                Icons.health_and_safety_outlined,
                Icons.school_outlined,
                Icons.monitor_heart_outlined
              ],
              onTap: () => context.go('/get-involved'),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _PhotoStory extends StatelessWidget {
  const _PhotoStory({
    required this.image,
    required this.tag,
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
    this.gradient = const [AppColors.apricot, AppColors.coral, AppColors.mochaDark],
    this.pattern = const [],
  });

  final String image;
  final List<Color> gradient;

  /// Icons scattered across the illustrated background (used when no photo exists yet).
  final List<IconData> pattern;
  final String tag;
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HoverLift(
      radius: 22,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: isMobile(context) ? 320 : 400,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _StoryIllustration(colors: gradient, icon: icon, pattern: pattern),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE62F211C)],
                  stops: [0.3, 1],
                ),
              ),
            ),
            Positioned(
              left: 22,
              top: 22,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 15, color: AppColors.coral),
                  const SizedBox(width: 6),
                  Text(tag, style: const TextStyle(color: AppColors.ink, fontSize: 12.5, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
            Positioned(
              left: 28,
              right: 28,
              bottom: 26,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(title, style: t.headlineMedium?.copyWith(color: Colors.white, fontSize: 23)),
                    const SizedBox(height: 6),
                    Text(text, style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
                  ]),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(color: AppColors.coral, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_outward_rounded, color: Colors.white, size: 22),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Illustrated stand-in for a story photo: gradient, scattered icons and a large central icon.
class _StoryIllustration extends StatelessWidget {
  const _StoryIllustration({required this.colors, required this.icon, required this.pattern});
  final List<Color> colors;
  final IconData icon;
  final List<IconData> pattern;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth, h = c.maxHeight;
      const spots = [
        (0.08, 0.30, 34.0, -0.3),
        (0.30, 0.10, 26.0, 0.2),
        (0.74, 0.08, 40.0, 0.15),
        (0.88, 0.34, 28.0, -0.2),
        (0.14, 0.62, 24.0, 0.25),
        (0.82, 0.60, 30.0, 0.1),
        (0.52, 0.04, 22.0, -0.15),
        (0.62, 0.42, 20.0, 0.3),
      ];
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
        child: Stack(children: [
          Positioned(
            right: -w * 0.12,
            top: -h * 0.18,
            child: Container(
              width: w * 0.6,
              height: w * 0.6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          if (pattern.isNotEmpty)
            for (var k = 0; k < spots.length; k++)
              Positioned(
                left: w * spots[k].$1,
                top: h * spots[k].$2,
                child: Transform.rotate(
                  angle: spots[k].$4,
                  child:
                      Icon(pattern[k % pattern.length], size: spots[k].$3, color: Colors.white.withValues(alpha: 0.18)),
                ),
              ),
          Positioned(
            left: 0,
            right: 0,
            top: h * 0.16,
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 2),
                ),
                child: Icon(icon, size: 56, color: Colors.white),
              ),
            ),
          ),
        ]),
      );
    });
  }
}

// ─────────────────────────── Presence ───────────────────────────

class _GlobalPresence extends StatelessWidget {
  const _GlobalPresence();

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final india = _PresenceCard(
      code: 'IN',
      country: 'India',
      title: 'VKN Charities',
      place: 'Coimbatore & Pollachi, Tamil Nadu',
      facts: const [
        (Icons.event_available_outlined, 'Active since', 'January 2020'),
        (Icons.receipt_long_outlined, '12A registration', '17 Dec 2022'),
        (Icons.volunteer_activism_outlined, '80G registration', '21 Dec 2022'),
      ],
      onTap: () => context.go('/about'),
    );
    final usa = _PresenceCard(
      code: 'US',
      country: 'United States',
      title: 'VKN Charities Inc.',
      place: 'Louisville, Kentucky',
      facts: const [
        (Icons.verified_outlined, 'Status', '501(c)(3) public charity'),
        (Icons.event_outlined, 'Tax-exempt since', 'September 2024'),
        (Icons.tag, 'EIN', '87-3637206'),
      ],
      onTap: () => context.go('/usa'),
    );

    // Heart medallion that links the two organisations.
    final link = Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.coral,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(color: AppColors.coral.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 24),
    );

    return Section(
      color: Colors.white,
      child: Column(children: [
        const SectionHeading(
          center: true,
          eyebrow: 'Where We Work',
          title: 'Rooted in Tamil Nadu, Supported Worldwide',
          subtitle: 'Two registered organisations, one shared mission of healing and care.',
        ),
        const SizedBox(height: 52),
        if (desktop)
          Stack(alignment: Alignment.center, children: [
            IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(child: india),
                const SizedBox(width: 28),
                Expanded(child: usa),
              ]),
            ),
            link,
          ])
        else
          Column(children: [india, const SizedBox(height: 12), link, const SizedBox(height: 12), usa]),
      ]),
    );
  }
}

class _PresenceCard extends StatelessWidget {
  const _PresenceCard({
    required this.code,
    required this.country,
    required this.title,
    required this.place,
    required this.facts,
    required this.onTap,
  });

  final String code;
  final String country;
  final String title;
  final String place;
  final List<(IconData, String, String)> facts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HoverLift(
      radius: 24,
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.shell,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(30, 26, 30, 26),
            color: AppColors.cream,
            child: Row(children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.peach, width: 4),
                ),
                child: Text(code,
                    style: const TextStyle(
                        color: AppColors.coral, fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(country.toUpperCase(),
                      style: const TextStyle(
                          color: AppColors.coral, fontSize: 11.5, fontWeight: FontWeight.w700, letterSpacing: 2)),
                  const SizedBox(height: 2),
                  Text(title, style: t.headlineSmall?.copyWith(color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.place_outlined, size: 15, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Flexible(child: Text(place, style: t.bodySmall?.copyWith(color: AppColors.muted))),
                  ]),
                ]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 14, 30, 26),
            child: Column(children: [
              for (final f in facts)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.line))),
                  child: Row(children: [
                    Icon(f.$1, size: 18, color: AppColors.coral),
                    const SizedBox(width: 12),
                    Expanded(child: Text(f.$2, style: t.bodyMedium?.copyWith(color: AppColors.muted))),
                    Flexible(
                      child: Text(f.$3,
                          textAlign: TextAlign.right,
                          style: t.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ),
              const SizedBox(height: 18),
              Row(children: [
                Text('Learn more', style: t.labelLarge?.copyWith(color: AppColors.mocha, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward, size: 16, color: AppColors.mocha),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
