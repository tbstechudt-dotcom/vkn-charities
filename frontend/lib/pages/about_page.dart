import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/blocks.dart';
import '../widgets/common.dart';
import '../widgets/decor.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageBody(children: [
      PageHero(
        eyebrow: 'About us',
        title: 'Compassion, rooted in tradition',
        subtitle: 'VKN Charities is a charitable organisation based in Coimbatore, Tamil Nadu, working since '
            'January 2020 for holistic health and the care of orphaned elders and children.',
        art: HeroArt.mandala,
        crumb: 'About Us',
        highlights: [
          (Icons.event_available_outlined, 'Since January 2020'),
          (Icons.location_on_outlined, 'Coimbatore & Pollachi'),
          (Icons.verified_outlined, '12A & 80G registered'),
        ],
      ),
      _Story(),
      _VisionMission(),
      _Founder(),
      _Values(),
      _Timeline(),
      CtaBand(
        title: 'Walk with us.',
        text: 'Join as a donor, volunteer or well-wisher and help us reach more lives.',
      ),
    ]);
  }
}

class _Story extends StatelessWidget {
  const _Story();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);

    final story = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeading(eyebrow: 'Our story', title: 'Why VKN Charities exists'),
      const SizedBox(height: 22),
      Text(
        'VKN Charities was started with a simple belief: good health and a dignified life should be within '
        'everyone\'s reach. Since January 2020 we have worked across Coimbatore and Pollachi to promote holistic '
        'health through yoga, meditation, Ayurveda, Siddha and alternative therapies.',
        style: t.bodyLarge,
      ),
      const SizedBox(height: 16),
      Text(
        'Alongside healing, we care for those society often forgets — elderly people left without family and '
        'children who have lost their parents — and support education so that young people can build a better '
        'future.',
        style: t.bodyLarge,
      ),
      const SizedBox(height: 30),
      const Wrap(spacing: 14, runSpacing: 14, children: [
        FactChip(icon: Icons.event_available_outlined, value: 'Since 2020', label: 'Serving communities'),
        FactChip(icon: Icons.verified_outlined, value: '12A & 80G', label: 'Registered in India'),
        FactChip(icon: Icons.public, value: '501(c)(3)', label: 'Affiliate in the USA'),
      ]),
    ]);

    const art = _ArchPhotos();

    return Section(
      color: Colors.white,
      child: desktop
          ? Row(children: [
              const Expanded(child: art),
              const SizedBox(width: 72),
              Expanded(child: story),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [story, const SizedBox(height: 44), art]),
    );
  }
}

/// Two tall arch-shaped photos, staggered, with a round "since" seal between them.
class _ArchPhotos extends StatelessWidget {
  const _ArchPhotos();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final h = mobile ? 360.0 : 520.0;

    Widget arch(String img, double height) => Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(400), bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.mochaDark.withValues(alpha: 0.12), blurRadius: 30, offset: const Offset(0, 14)),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(400), bottom: Radius.circular(24)),
            child: Image.asset(img, fit: BoxFit.cover, width: double.infinity),
          ),
        );

    return SizedBox(
      height: h,
      child: Stack(clipBehavior: Clip.none, children: [
        // Soft peach backdrop shape behind the arches.
        Positioned(
          left: mobile ? 10 : 30,
          right: mobile ? 10 : 30,
          top: h * 0.18,
          bottom: h * 0.06,
          child: Container(
            decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(32)),
          ),
        ),
        Positioned.fill(
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: arch('assets/images/about.jpg', h * 0.86)),
            SizedBox(width: mobile ? 14 : 22),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: h * 0.14),
                child: arch('assets/images/children.jpg', h * 0.86),
              ),
            ),
          ]),
        ),
        // Round seal straddling the two arches.
        Positioned(
          left: 0,
          right: 0,
          bottom: mobile ? 8 : 18,
          child: Center(
            child: Container(
              width: mobile ? 104 : 128,
              height: mobile ? 104 : 128,
              decoration: BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 6),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.coral.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10)),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: FittedBox(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('SINCE',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: mobile ? 10 : 11,
                          letterSpacing: 2.5,
                          fontWeight: FontWeight.w600)),
                  Text('2020',
                      style: TextStyle(
                          color: Colors.white, fontSize: mobile ? 24 : 30, fontWeight: FontWeight.w700, height: 1.15)),
                  Text('Tamil Nadu',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: mobile ? 9.5 : 10.5)),
                ]),
              ),
            ),
          ),
        ),
        const Positioned(left: -6, top: 30, child: DecoRing(size: 16)),
        const Positioned(right: 4, top: 6, child: DecoCross(size: 20)),
      ]),
    );
  }
}

class _VisionMission extends StatelessWidget {
  const _VisionMission();

  @override
  Widget build(BuildContext context) {
    return const Section(
      color: AppColors.shell,
      child: Column(children: [
        SectionHeading(eyebrow: 'Our purpose', title: 'Vision & mission', center: true),
        SizedBox(height: 48),
        ResponsiveGrid(desktop: 2, children: [
          _PurposeCard(
            icon: Icons.visibility_outlined,
            label: 'Our vision',
            text: 'A healthy, compassionate society where every person — young or old — can live with wellbeing, '
                'care and dignity.',
          ),
          _PurposeCard(
            icon: Icons.flag_outlined,
            label: 'Our mission',
            text: 'To promote holistic health through yoga, meditation and traditional medicine, and to provide '
                'care, shelter and education for orphaned elders and children.',
          ),
        ]),
      ]),
    );
  }
}

class _PurposeCard extends StatelessWidget {
  const _PurposeCard({required this.icon, required this.label, required this.text});
  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final mobile = isMobile(context);
    return HoverLift(
      radius: 22,
      child: Container(
        constraints: BoxConstraints(minHeight: mobile ? 0 : 250),
        padding: EdgeInsets.all(mobile ? 26 : 38),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.line),
        ),
        child: Stack(children: [
          Positioned(
            right: -6,
            top: -10,
            child: Icon(icon, size: 110, color: AppColors.peach.withValues(alpha: 0.45)),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 24),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    color: AppColors.coral, fontSize: 12.5, fontWeight: FontWeight.w700, letterSpacing: 2)),
            const SizedBox(height: 10),
            Text(text,
                style: t.titleMedium
                    ?.copyWith(color: AppColors.ink, height: 1.65, fontSize: 18, fontWeight: FontWeight.w400)),
          ]),
        ]),
      ),
    );
  }
}

class _Founder extends StatelessWidget {
  const _Founder();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);

    final portrait = Column(children: [
      Container(
        width: 220,
        height: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.apricot.withValues(alpha: 0.6), width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1)),
          // Replace with Image.asset('assets/images/founder.jpg') when a photo is available.
          child: const Icon(Icons.person, size: 110, color: Colors.white54),
        ),
      ),
      const SizedBox(height: 20),
      Text('Dr. Krishna Nadar', style: t.headlineSmall?.copyWith(color: Colors.white)),
      const SizedBox(height: 4),
      Text('FOUNDER PRESIDENT',
          style: t.labelMedium?.copyWith(color: AppColors.apricot, letterSpacing: 2, fontWeight: FontWeight.w600)),
    ]);

    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const DarkPill('Leadership', icon: Icons.workspace_premium_outlined),
      const SizedBox(height: 18),
      Text('Guided by a founder devoted to healing',
          style: (desktop ? t.displaySmall : t.headlineMedium)?.copyWith(color: Colors.white, height: 1.2)),
      const SizedBox(height: 16),
      Text(
        'As Founder President, Dr. Krishna Nadar guides VKN Charities in Coimbatore and its holistic healing '
        'and yoga initiatives at Puravipalayam, Pollachi.',
        style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.82)),
      ),
      const SizedBox(height: 28),
      const DarkIconRow(
          icon: Icons.location_city_outlined, title: 'VKN Charities, Coimbatore', text: 'Founder President'),
      const SizedBox(height: 12),
      const DarkIconRow(
          icon: Icons.spa_outlined, title: 'Pollachi initiative', text: 'Holistic healing & yoga at Puravipalayam'),
      const SizedBox(height: 28),
      FilledButton(
        onPressed: () => context.go('/programs'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.coral,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
        ),
        child: const Text('Explore our work'),
      ),
    ]);

    return DarkSection(
      child: desktop
          ? Row(children: [
              Expanded(flex: 4, child: Center(child: portrait)),
              const SizedBox(width: 64),
              Expanded(flex: 6, child: text),
            ])
          : Column(children: [portrait, const SizedBox(height: 40), text]),
    );
  }
}

class _Values extends StatelessWidget {
  const _Values();

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    final h = mobile ? 0.0 : 230.0;
    return Section(
      color: Colors.white,
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'Our values',
          title: 'What guides us',
          subtitle: 'Four promises we keep to every person we serve.',
          center: true,
        ),
        const SizedBox(height: 48),
        ResponsiveGrid(desktop: 4, children: [
          InfoCard(
              center: true,
              icon: Icons.favorite_border,
              title: 'Compassion',
              text: 'We serve every person with kindness and respect.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.spa_outlined,
              title: 'Holistic care',
              text: 'We care for body, mind and spirit together.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.handshake_outlined,
              title: 'Dignity',
              text: 'Every elder and child deserves a life of dignity.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.verified_outlined,
              title: 'Transparency',
              text: 'Registered and accountable in India and the USA.',
              minHeight: h),
        ]),
      ]),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  static const _events = [
    (
      Icons.flag_outlined,
      'January 2020',
      'Activities begin',
      'VKN Charities starts its work in Coimbatore, Tamil Nadu.'
    ),
    (
      Icons.receipt_long_outlined,
      '17 December 2022',
      '12A registration',
      'Registered under Section 12A of the Income Tax Act.'
    ),
    (
      Icons.volunteer_activism_outlined,
      '21 December 2022',
      '80G registration',
      'Donations become eligible for tax benefit under Section 80G.'
    ),
    (
      Icons.public,
      'September 2024',
      'VKN Charities Inc. (USA)',
      'Recognised as a 501(c)(3) tax-exempt public charity.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    return Section(
      color: AppColors.shell,
      child: Column(children: [
        const SectionHeading(eyebrow: 'Milestones', title: 'Our journey so far', center: true),
        const SizedBox(height: 52),
        for (var i = 0; i < _events.length; i++) desktop ? _desktopRow(i) : _mobileRow(i),
      ]),
    );
  }

  Widget _card(int i, {TextAlign align = TextAlign.start}) {
    final e = _events[i];
    return _MilestoneCard(date: e.$2, title: e.$3, text: e.$4, align: align);
  }

  Widget _dot(int i) => Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.peach, width: 5),
        ),
        child: Icon(_events[i].$1, size: 22, color: AppColors.coral),
      );

  Widget _desktopRow(int i) {
    final left = i.isEven;
    return CustomPaint(
      painter: _SpinePainter(center: true, first: i == 0, last: i == _events.length - 1, dotY: 18 + 26),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: left
                ? Align(alignment: Alignment.centerRight, child: _card(i, align: TextAlign.right))
                : const SizedBox(),
          ),
        ),
        SizedBox(width: 120, child: Padding(padding: const EdgeInsets.only(top: 18), child: Center(child: _dot(i)))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: left ? const SizedBox() : Align(alignment: Alignment.centerLeft, child: _card(i)),
          ),
        ),
      ]),
    );
  }

  Widget _mobileRow(int i) {
    return CustomPaint(
      painter: _SpinePainter(center: false, first: i == 0, last: i == _events.length - 1, dotY: 26),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _dot(i),
        const SizedBox(width: 16),
        Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _card(i))),
      ]),
    );
  }
}

/// Draws this row's piece of the timeline line, so rows can size to their content.
class _SpinePainter extends CustomPainter {
  const _SpinePainter({required this.center, required this.first, required this.last, required this.dotY});
  final bool center;
  final bool first;
  final bool last;
  final double dotY;

  @override
  void paint(Canvas canvas, Size size) {
    final x = center ? size.width / 2 : 26.0;
    final top = first ? dotY : 0.0;
    final bottom = last ? dotY : size.height;
    if (bottom <= top) return;
    canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        Paint()
          ..color = AppColors.apricot
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant _SpinePainter old) =>
      old.center != center || old.first != first || old.last != last || old.dotY != dotY;
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.date, required this.title, required this.text, this.align = TextAlign.start});
  final String date;
  final String title;
  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cross = align == TextAlign.right ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: HoverLift(
        radius: 18,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(crossAxisAlignment: cross, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: AppColors.blush, borderRadius: BorderRadius.circular(20)),
              child: Text(date,
                  style: const TextStyle(color: AppColors.coral, fontSize: 12.5, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: align, style: t.headlineSmall?.copyWith(color: AppColors.ink)),
            const SizedBox(height: 6),
            Text(text, textAlign: align, style: t.bodyMedium?.copyWith(color: AppColors.muted)),
          ]),
        ),
      ),
    );
  }
}
