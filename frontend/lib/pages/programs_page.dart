import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/content.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../widgets/blocks.dart';
import '../widgets/common.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<ProgramsPage> createState() => _ProgramsPageState();
}

class _ProgramsPageState extends State<ProgramsPage> {
  // Loaded from Node.js → Supabase `programs` table (falls back to built-in list).
  late final Future<List<Program>> _programs = ApiService.instance.fetchPrograms();
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return PageBody(children: [
      const PageHero(
        eyebrow: 'Our work',
        title: 'Programmes that heal and uplift',
        subtitle: 'Holistic health, traditional medicine, and loving care for orphaned elders and children — '
            'here is how we serve.',
        art: HeroArt.orbit,
        crumb: 'Our Work',
        highlights: [
          (Icons.spa_outlined, 'Healing'),
          (Icons.self_improvement, 'Wellbeing'),
          (Icons.volunteer_activism_outlined, 'Care'),
          (Icons.school_outlined, 'Education'),
        ],
      ),
      Section(
        child: FutureBuilder<List<Program>>(
          future: _programs,
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Padding(
                padding: EdgeInsets.all(60),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final all = snap.data!;
            final cats = [
              'All',
              ...{for (final p in all) p.category}
            ];
            final shown = _filter == 'All' ? all : all.where((p) => p.category == _filter).toList();
            int countOf(String c) => c == 'All' ? all.length : all.where((p) => p.category == c).length;

            return Column(children: [
              Center(
                child: PillTabs(
                  tabs: [for (final c in cats) PillTab(c, _tabIcon(c), count: countOf(c))],
                  selected: cats.indexOf(_filter).clamp(0, cats.length - 1),
                  onSelect: (i) => setState(() => _filter = cats[i]),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _filter == 'All'
                    ? 'Showing all ${shown.length} programmes'
                    : '${shown.length} ${shown.length == 1 ? 'programme' : 'programmes'} in $_filter',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.topLeft,
                child: FadeSwitch(
                  child: ResponsiveGrid(
                    key: ValueKey(_filter),
                    children: [
                      for (final p in shown)
                        InfoCard(
                          icon: iconFor(p.icon),
                          title: p.title,
                          tag: p.location == null ? p.category : '${p.category} · ${p.location}',
                          text: p.summary,
                          minHeight: 270,
                        ),
                    ],
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
      const _PollachiInitiative(),
      const _HowWeWork(),
      const CtaBand(
        title: 'Help us open more doors.',
        text: 'Support a programme, sponsor care for an elder or child, or volunteer your skills.',
      ),
    ]);
  }
}

IconData _tabIcon(String category) {
  switch (category.toLowerCase()) {
    case 'all':
      return Icons.grid_view_rounded;
    case 'healing':
      return Icons.spa_outlined;
    case 'wellbeing':
      return Icons.self_improvement;
    case 'care':
      return Icons.volunteer_activism_outlined;
    case 'education':
      return Icons.school_outlined;
    default:
      return Icons.label_outline;
  }
}

class _PollachiInitiative extends StatelessWidget {
  const _PollachiInitiative();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final desktop = isDesktop(context);

    final text = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const DarkPill('Featured initiative'),
      const SizedBox(height: 18),
      Text('Holistic Healing at Puravipalayam, Pollachi',
          style: (desktop ? t.displaySmall : t.headlineMedium)?.copyWith(color: Colors.white, height: 1.2)),
      const SizedBox(height: 16),
      Text(
        'Led by our Founder President, Dr. Krishna Nadar, the Pollachi initiative is the home of our holistic '
        'healing and yoga work — a peaceful setting for practice, therapy and rejuvenation.',
        style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.82)),
      ),
      const SizedBox(height: 28),
      const DarkIconRow(icon: Icons.self_improvement, title: 'Yoga', text: 'Daily practice & guided sessions'),
      const SizedBox(height: 12),
      const DarkIconRow(icon: Icons.spa_outlined, title: 'Meditation', text: 'Mindfulness and inner balance'),
      const SizedBox(height: 12),
      const DarkIconRow(icon: Icons.healing_outlined, title: 'Therapies', text: 'Traditional & natural healing'),
      const SizedBox(height: 32),
      Wrap(spacing: 14, runSpacing: 12, children: [
        FilledButton(
          onPressed: () => context.go('/get-involved'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coral,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
          child: const Text('Support this initiative'),
        ),
        OutlinedButton(
          onPressed: () => context.go('/about'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white54),
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          ),
          child: const Text('Meet our founder'),
        ),
      ]),
    ]);

    const art = PhotoCollage(
      main: 'assets/images/retreat.jpg',
      small: 'assets/images/meditation.jpg',
      badgeIcon: Icons.location_on_outlined,
      badgeTitle: 'Pollachi, Tamil Nadu',
      badgeSubtitle: 'Healing & yoga centre',
      frameColor: AppColors.mochaDark,
    );

    return DarkSection(
      child: desktop
          ? Row(children: [
              const Expanded(child: art),
              const SizedBox(width: 72),
              Expanded(child: text),
            ])
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              text,
              const SizedBox(height: 44),
              art,
            ]),
    );
  }
}

class _HowWeWork extends StatelessWidget {
  const _HowWeWork();

  @override
  Widget build(BuildContext context) {
    return const Section(
      color: AppColors.shell,
      child: Column(children: [
        SectionHeading(
          eyebrow: 'How we work',
          title: 'Simple, personal, lasting',
          subtitle: 'Three steps guide everything we do — from a first conversation to lasting change.',
          center: true,
        ),
        SizedBox(height: 56),
        ProcessSteps(steps: [
          (Icons.hearing_outlined, 'Listen', 'We understand the needs of each individual and community we serve.'),
          (
            Icons.volunteer_activism_outlined,
            'Care',
            'We provide healing, shelter, nutrition and companionship with respect.'
          ),
          (
            Icons.trending_up_rounded,
            'Empower',
            'Through yoga, education and awareness, we help people thrive on their own.'
          ),
        ]),
      ]),
    );
  }
}
