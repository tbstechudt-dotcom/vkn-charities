import 'package:flutter/material.dart';

import '../config.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../widgets/blocks.dart';
import '../widgets/common.dart';
import '../widgets/decor.dart';
import '../widgets/submit_form.dart';

const _tabKeys = ['donate', 'volunteer', 'contact'];

class GetInvolvedPage extends StatefulWidget {
  const GetInvolvedPage({super.key, this.initialTab});

  /// 'donate', 'volunteer' or 'contact' (from ?tab=...).
  final String? initialTab;

  @override
  State<GetInvolvedPage> createState() => _GetInvolvedPageState();
}

class _GetInvolvedPageState extends State<GetInvolvedPage> {
  final _formsKey = GlobalKey();
  late int _tab = _indexFor(widget.initialTab);

  static int _indexFor(String? key) => key == null ? 0 : _tabKeys.indexOf(key).clamp(0, _tabKeys.length - 1);

  @override
  void initState() {
    super.initState();
    if (widget.initialTab != null) WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToForms());
  }

  @override
  void didUpdateWidget(covariant GetInvolvedPage old) {
    super.didUpdateWidget(old);
    if (old.initialTab != widget.initialTab && widget.initialTab != null) {
      setState(() => _tab = _indexFor(widget.initialTab));
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToForms());
    }
  }

  void _scrollToForms() {
    final ctx = _formsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic);
    }
  }

  void _select(int i, {bool scroll = false}) {
    setState(() => _tab = i);
    if (scroll) _scrollToForms();
  }

  @override
  Widget build(BuildContext context) {
    final sections = [const _DonateSection(), const _VolunteerSection(), const _ContactSection()];
    return PageBody(children: [
      const PageHero(
        eyebrow: 'Get involved',
        title: 'Give, serve, or simply say hello',
        subtitle: 'There are many ways to be part of VKN Charities. Choose what feels right for you.',
        art: HeroArt.hearts,
        crumb: 'Get Involved',
        highlights: [
          (Icons.volunteer_activism_outlined, 'Donate'),
          (Icons.groups_outlined, 'Volunteer'),
          (Icons.mail_outline, 'Contact us'),
        ],
      ),
      _Ways(selected: _tab, onSelect: (i) => _select(i, scroll: true)),
      Section(
        key: _formsKey,
        color: AppColors.shell,
        child: Column(children: [
          const SectionHeading(
            eyebrow: 'Take the next step',
            title: 'How would you like to help?',
            center: true,
          ),
          const SizedBox(height: 32),
          PillTabs(
            tabs: const [
              PillTab('Donate', Icons.volunteer_activism_outlined),
              PillTab('Volunteer', Icons.groups_outlined),
              PillTab('Contact', Icons.mail_outline),
            ],
            selected: _tab,
            onSelect: _select,
          ),
          const SizedBox(height: 44),
          FadeSwitch(child: KeyedSubtree(key: ValueKey(_tab), child: sections[_tab])),
        ]),
      ),
    ]);
  }
}

class _Ways extends StatelessWidget {
  const _Ways({required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const ways = [
      (
        Icons.volunteer_activism_outlined,
        'Donate',
        'Support healing programmes and care for orphaned elders and children.',
        'Make a pledge'
      ),
      (
        Icons.groups_outlined,
        'Volunteer',
        'Teach yoga, spend time with elders, help children learn, or lend your skills.',
        'Sign up'
      ),
      (
        Icons.campaign_outlined,
        'Spread the word',
        'Tell friends and family about our work, or write to us about partnerships and visits.',
        'Get in touch'
      ),
    ];
    return Section(
      color: Colors.white,
      child: Column(children: [
        const SectionHeading(eyebrow: 'Ways to help', title: 'Every kind of help matters', center: true),
        const SizedBox(height: 48),
        ResponsiveGrid(children: [
          for (var i = 0; i < ways.length; i++)
            _WayCard(
              icon: ways[i].$1,
              title: ways[i].$2,
              text: ways[i].$3,
              action: ways[i].$4,
              active: selected == i,
              onTap: () => onSelect(i),
            ),
        ]),
      ]),
    );
  }
}

class _WayCard extends StatelessWidget {
  const _WayCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.action,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String text;
  final String action;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return HoverLift(
      radius: 20,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        constraints: BoxConstraints(minHeight: isMobile(context) ? 0 : 290),
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        decoration: BoxDecoration(
          color: active ? AppColors.cream : AppColors.shell,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.coral : AppColors.line, width: active ? 1.5 : 1),
        ),
        child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: 68,
            height: 68,
            decoration: BoxDecoration(color: active ? AppColors.coral : AppColors.blush, shape: BoxShape.circle),
            child: Icon(icon, color: active ? Colors.white : AppColors.coral, size: 30),
          ),
          const SizedBox(height: 22),
          Text(title, textAlign: TextAlign.center, style: t.headlineSmall),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: t.bodyMedium),
          const SizedBox(height: 20),
          Row(mainAxisSize: MainAxisSize.min, children: [
            Text(action, style: const TextStyle(color: AppColors.coral, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.coral),
          ]),
        ]),
      ),
    );
  }
}

/// Two-column layout: dark info panel on the left, white form card on the right.
class _FormSection extends StatelessWidget {
  const _FormSection({required this.info, required this.form});
  final Widget info;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktop(context);
    final mobile = isMobile(context);
    final panel = Container(
      padding: EdgeInsets.all(mobile ? 26 : 36),
      decoration: BoxDecoration(color: AppColors.mochaDark, borderRadius: BorderRadius.circular(24)),
      child: info,
    );
    final card = Container(
      padding: EdgeInsets.all(mobile ? 22 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(color: AppColors.mochaDark.withValues(alpha: 0.08), blurRadius: 34, offset: const Offset(0, 16)),
        ],
      ),
      child: form,
    );
    return desktop
        ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 4, child: panel),
            const SizedBox(width: 28),
            Expanded(flex: 6, child: card),
          ])
        : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [panel, const SizedBox(height: 24), card]);
  }
}

class _PanelHeading extends StatelessWidget {
  const _PanelHeading({required this.pill, required this.pillIcon, required this.title, required this.text});
  final String pill;
  final IconData pillIcon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DarkPill(pill, icon: pillIcon),
      const SizedBox(height: 16),
      Text(title, style: t.headlineMedium?.copyWith(color: Colors.white, height: 1.2)),
      const SizedBox(height: 12),
      Text(text, style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
      const SizedBox(height: 24),
    ]);
  }
}

const _gap = SizedBox(height: 12);

class _DonateSection extends StatelessWidget {
  const _DonateSection();

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      info: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PanelHeading(
          pill: 'Donate',
          pillIcon: Icons.volunteer_activism_outlined,
          title: 'Make a pledge',
          text: 'Tell us how you would like to help. Our team will email you the bank / payment details '
              'and send your receipt once the gift is received.',
        ),
        DarkIconRow(
          check: false,
          icon: Icons.receipt_long_outlined,
          title: 'India — Section 80G',
          text: 'Donations are eligible for deduction under Section 80G, subject to the applicable limits.',
        ),
        _gap,
        DarkIconRow(
          check: false,
          icon: Icons.account_balance_outlined,
          title: 'USA — 501(c)(3)',
          text: 'Gifts to VKN Charities Inc. (EIN 87-3637206) may be tax-deductible to the extent allowed by law.',
        ),
        _gap,
        DarkIconRow(
          check: false,
          icon: Icons.lock_outline,
          title: 'No payment on this site',
          text: 'This form only records your pledge. Never share card or bank PINs with anyone.',
        ),
      ]),
      form: SubmitForm(
        buttonLabel: 'Submit pledge',
        onSubmit: ApiService.instance.submitPledge,
        fields: const [
          FieldSpec('name', 'Full name', required: true, half: true),
          FieldSpec('email', 'Email', kind: FieldKind.email, required: true, half: true),
          FieldSpec('phone', 'Phone', kind: FieldKind.phone, half: true),
          FieldSpec('entity', 'Donate to', kind: FieldKind.dropdown, half: true, options: [
            ('india', 'VKN Charities — India (₹)'),
            ('usa', 'VKN Charities Inc. — USA (\$)'),
          ]),
          FieldSpec('amount', 'Amount (₹ for India, \$ for USA)', kind: FieldKind.amount, required: true, half: true),
          FieldSpec('purpose', 'Purpose', kind: FieldKind.dropdown, half: true, options: [
            ('General', 'Where it is needed most'),
            ('Elder care', 'Care for orphaned elders'),
            ('Child care', 'Care for orphaned children'),
            ('Healing centres', 'Holistic healing & yoga'),
            ('Education', 'Education'),
          ]),
          FieldSpec('message', 'Message (optional)', kind: FieldKind.multiline),
        ],
      ),
    );
  }
}

class _VolunteerSection extends StatelessWidget {
  const _VolunteerSection();

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      info: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PanelHeading(
          pill: 'Volunteer',
          pillIcon: Icons.groups_outlined,
          title: 'Share your time and talent',
          text: 'Whether you can give an hour a week or a few days a month, your presence makes a real difference.',
        ),
        DarkIconRow(icon: Icons.self_improvement, title: 'Yoga & meditation', text: 'Lead or assist sessions'),
        _gap,
        DarkIconRow(icon: Icons.elderly, title: 'Elder care', text: 'Reading, talking, caring'),
        _gap,
        DarkIconRow(icon: Icons.school_outlined, title: 'Children', text: 'Tutor and mentor'),
        _gap,
        DarkIconRow(icon: Icons.event_outlined, title: 'Events & skills', text: 'Outreach, design or accounts'),
      ]),
      form: SubmitForm(
        buttonLabel: 'Sign up to volunteer',
        onSubmit: ApiService.instance.submitVolunteer,
        fields: const [
          FieldSpec('name', 'Full name', required: true, half: true),
          FieldSpec('email', 'Email', kind: FieldKind.email, required: true, half: true),
          FieldSpec('phone', 'Phone', kind: FieldKind.phone, required: true, half: true),
          FieldSpec('city', 'City', half: true),
          FieldSpec('interest', 'Area of interest', kind: FieldKind.dropdown, half: true, options: [
            ('Yoga & meditation', 'Yoga & meditation'),
            ('Elder care', 'Elder care'),
            ('Children & education', 'Children & education'),
            ('Events & outreach', 'Events & outreach'),
            ('Professional skills', 'Professional skills'),
          ]),
          FieldSpec('availability', 'Availability', kind: FieldKind.dropdown, half: true, options: [
            ('Weekends', 'Weekends'),
            ('Weekdays', 'Weekdays'),
            ('Occasional / events', 'Occasional / events'),
            ('Remote', 'Remote'),
          ]),
          FieldSpec('message', 'Tell us a little about yourself', kind: FieldKind.multiline),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return _FormSection(
      info: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _PanelHeading(
          pill: 'Contact',
          pillIcon: Icons.mail_outline,
          title: 'We would love to hear from you',
          text: 'Questions about our programmes, visits, partnerships or receipts — write to us.',
        ),
        DarkIconRow(
          check: false,
          icon: Icons.location_on_outlined,
          title: 'India',
          text: '${AppConfig.addressLine1}\n${AppConfig.addressLine2}',
        ),
        _gap,
        DarkIconRow(check: false, icon: Icons.public, title: 'USA', text: AppConfig.usAddress),
        _gap,
        DarkIconRow(check: false, icon: Icons.mail_outline, title: 'Email', text: AppConfig.email),
        _gap,
        DarkIconRow(check: false, icon: Icons.phone_outlined, title: 'Phone', text: AppConfig.phone),
      ]),
      form: SubmitForm(
        buttonLabel: 'Send message',
        onSubmit: ApiService.instance.submitContact,
        fields: const [
          FieldSpec('name', 'Full name', required: true, half: true),
          FieldSpec('email', 'Email', kind: FieldKind.email, required: true, half: true),
          FieldSpec('phone', 'Phone', kind: FieldKind.phone, half: true),
          FieldSpec('subject', 'Subject', half: true),
          FieldSpec('message', 'Message', kind: FieldKind.multiline, required: true),
        ],
      ),
    );
  }
}
