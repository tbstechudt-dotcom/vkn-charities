import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config.dart';
import '../theme.dart';
import '../widgets/blocks.dart';
import '../widgets/common.dart';

class UsaPage extends StatelessWidget {
  const UsaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageBody(children: [
      PageHero(
        eyebrow: 'VKN Charities Inc. · United States',
        title: 'Supporting our mission from the USA',
        subtitle: 'VKN Charities Inc. is a 501(c)(3) public charity based in Louisville, Kentucky, '
            'tax-exempt since September 2024.',
        art: HeroArt.seal,
        crumb: 'VKN USA',
        highlights: [
          (Icons.verified_outlined, '501(c)(3) public charity'),
          (Icons.tag, 'EIN 87-3637206'),
          (Icons.location_on_outlined, 'Louisville, Kentucky'),
        ],
      ),
      _Overview(),
      _Mission(),
      _Financials(),
      _HowToGive(),
      CtaBand(
        title: 'Give from the United States.',
        text: 'Contributions to VKN Charities Inc. may be tax-deductible to the extent allowed by law.',
      ),
    ]);
  }
}

class _Overview extends StatelessWidget {
  const _Overview();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);

    final intro = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeading(eyebrow: 'Overview', title: 'An affiliated U.S. public charity'),
      const SizedBox(height: 20),
      Text(
        'VKN Charities Inc. shares the vision of VKN Charities in Tamil Nadu: holistic health, yoga, meditation, '
        'alternative therapies and care for elderly people and orphans. It gives friends and supporters in the '
        'United States a trusted way to take part in this work.',
        style: t.bodyLarge,
      ),
      const SizedBox(height: 22),
      const Bullet('Registered 501(c)(3) public charity'),
      const Bullet('Gifts may be tax-deductible to the extent allowed by law'),
      const Bullet('Annual information return filed with the IRS'),
      const SizedBox(height: 18),
      Wrap(spacing: 12, runSpacing: 12, children: [
        FilledButton(onPressed: () => context.go('/get-involved'), child: const Text('Make a pledge')),
        OutlinedButton(onPressed: () => context.go('/about'), child: const Text('About VKN Charities')),
      ]),
    ]);

    final facts = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.08), blurRadius: 34, offset: const Offset(0, 16)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          color: AppColors.mochaDark,
          padding: const EdgeInsets.fromLTRB(28, 22, 28, 22),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AppColors.peach, shape: BoxShape.circle),
              child: const Icon(Icons.account_balance_outlined, color: AppColors.mochaDark, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Key facts', style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                Text('VKN Charities Inc.', style: t.bodySmall?.copyWith(color: Colors.white70)),
              ]),
            ),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 8, 28, 14),
          child: Column(children: [
            _FactRow(Icons.badge_outlined, 'Legal name', 'VKN Charities Inc.'),
            _FactRow(Icons.location_on_outlined, 'Location', AppConfig.usAddress),
            _FactRow(Icons.tag, 'EIN', '87-3637206'),
            _FactRow(Icons.verified_outlined, 'Status', '501(c)(3) public charity'),
            _FactRow(Icons.event_outlined, 'Tax-exempt since', 'September 2024'),
            _FactRow(Icons.description_outlined, 'Annual return', 'IRS Form 990-EZ', last: true),
          ]),
        ),
      ]),
    );

    return Section(
      color: Colors.white,
      child: desktop
          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Expanded(flex: 6, child: intro),
              const SizedBox(width: 64),
              Expanded(flex: 5, child: facts),
            ])
          : Column(children: [intro, const SizedBox(height: 40), facts]),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow(this.icon, this.label, this.value, {this.last = false});
  final IconData icon;
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.coral),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: t.bodyMedium?.copyWith(color: AppColors.muted))),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: t.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class _Mission extends StatelessWidget {
  const _Mission();

  @override
  Widget build(BuildContext context) {
    final h = isMobile(context) ? 0.0 : 230.0;
    return Section(
      color: AppColors.shell,
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'Stated mission',
          title: 'What VKN Charities Inc. works to establish and maintain',
          center: true,
        ),
        const SizedBox(height: 48),
        ResponsiveGrid(children: [
          InfoCard(
              center: true,
              icon: Icons.spa_outlined,
              title: 'Holistic healing centres',
              text: 'Places of integrated, whole-person care.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.self_improvement,
              title: 'Yoga & meditation retreats',
              text: 'Spaces for practice, reflection and renewal.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.healing_outlined,
              title: 'Alternative medicine centres',
              text: 'Treatment rooted in natural and traditional systems.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.child_care,
              title: 'Orphanages',
              text: 'A safe and loving home for children in need.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.elderly,
              title: 'Old age homes',
              text: 'Shelter, care and companionship for elders.',
              minHeight: h),
          InfoCard(
              center: true,
              icon: Icons.park_outlined,
              title: 'Relief & recharge centres',
              text: 'Calm places to rest, restore and recover.',
              minHeight: h),
        ]),
      ]),
    );
  }
}

class _Financials extends StatelessWidget {
  const _Financials();

  // FY 2024, IRS Form 990-EZ (rounded).
  static const _revenue = 115.0;
  static const _expenses = 16.1;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);
    const share = _expenses / _revenue;

    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const DarkPill('Transparency', icon: Icons.insights_outlined),
      const SizedBox(height: 18),
      Text('Financial snapshot — FY 2024',
          style: (desktop ? t.displaySmall : t.headlineMedium)?.copyWith(color: Colors.white, height: 1.2)),
      const SizedBox(height: 16),
      Text(
        'As reported on IRS Form 990-EZ. Figures are rounded. Public filings for U.S. tax-exempt organisations '
        'are available from the IRS.',
        style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.82)),
      ),
      const SizedBox(height: 28),
      Text('Expenses as a share of revenue', style: t.bodyMedium?.copyWith(color: Colors.white70)),
      const SizedBox(height: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(children: [
          Container(height: 14, color: Colors.white.withValues(alpha: 0.12)),
          FractionallySizedBox(
            widthFactor: share,
            child: Container(height: 14, color: AppColors.apricot),
          ),
        ]),
      ),
      const SizedBox(height: 8),
      Text('≈ ${(share * 100).round()}% of FY 2024 revenue',
          style: t.bodySmall?.copyWith(color: AppColors.apricot, fontWeight: FontWeight.w600)),
    ]);

    const stats = Column(children: [
      DarkStat(icon: Icons.trending_up_rounded, value: r'$115K', label: 'Total revenue'),
      SizedBox(height: 14),
      DarkStat(icon: Icons.payments_outlined, value: r'$16.1K', label: 'Total expenses'),
      SizedBox(height: 14),
      DarkStat(icon: Icons.description_outlined, value: '990-EZ', label: 'Annual information return'),
    ]);

    return DarkSection(
      child: desktop
          ? Row(children: [
              Expanded(flex: 6, child: text),
              const SizedBox(width: 72),
              const Expanded(flex: 4, child: stats),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [text, const SizedBox(height: 36), stats]),
    );
  }
}

class _HowToGive extends StatelessWidget {
  const _HowToGive();

  @override
  Widget build(BuildContext context) {
    return const Section(
      color: AppColors.shell,
      child: Column(children: [
        SectionHeading(
          eyebrow: 'How to give',
          title: 'Giving from the USA is simple',
          subtitle: 'No payment is taken on this website — we guide you personally.',
          center: true,
        ),
        SizedBox(height: 56),
        ProcessSteps(steps: [
          (Icons.edit_note_outlined, 'Make a pledge', 'Fill in the short pledge form and choose VKN Charities Inc.'),
          (Icons.mark_email_read_outlined, 'Get payment details', 'Our team emails you the payment details.'),
          (Icons.receipt_long_outlined, 'Receive your receipt', 'We send your receipt once the gift is received.'),
        ]),
      ]),
    );
  }
}
