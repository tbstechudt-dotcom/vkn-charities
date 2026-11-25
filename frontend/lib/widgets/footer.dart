import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../theme.dart';
import 'common.dart';
import 'site_shell.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final white70 = t.bodyMedium?.copyWith(color: Colors.white70);
    final heading = t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700);

    Widget col(String title, List<Widget> children) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title, style: heading), const SizedBox(height: 16), ...children],
        );

    Widget link(String label, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(onTap: onTap, child: Text(label, style: white70)),
        );

    final columns = <Widget>[
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Logo(light: true),
        const SizedBox(height: 18),
        Text(
          'A registered charitable organisation in Tamil Nadu, India, working for holistic health, '
          'yoga, meditation, traditional medicine and the care of orphaned elders and children.',
          style: white70,
        ),
      ]),
      col('Explore', [
        for (final item in navItems) link(item.label, () => context.go(item.path)),
      ]),
      col('India Office', [
        Text(AppConfig.addressLine1, style: white70),
        Text(AppConfig.addressLine2, style: white70),
        const SizedBox(height: 10),
        link(AppConfig.email, () => launchUrl(Uri.parse('mailto:${AppConfig.email}'))),
        link(AppConfig.phone, () => launchUrl(Uri.parse('tel:${AppConfig.phone.replaceAll(' ', '')}'))),
      ]),
      col('Registrations', [
        Text('12A — granted 17 Dec 2022', style: white70),
        const SizedBox(height: 6),
        Text('80G — granted 21 Dec 2022', style: white70),
        const SizedBox(height: 6),
        Text('VKN Charities Inc. (USA)\n501(c)(3) · EIN 87-3637206', style: white70),
      ]),
    ];

    return Container(
      color: AppColors.espresso,
      child: Column(children: [
        Section(
          vertical: isMobile(context) ? 48 : 72,
          child: ResponsiveGrid(desktop: 4, tablet: 2, spacing: 40, children: columns),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white12))),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text(
            '© ${DateTime.now().year} VKN Charities. All rights reserved.',
            textAlign: TextAlign.center,
            style: t.bodySmall?.copyWith(color: Colors.white54),
          ),
        ),
      ]),
    );
  }
}
