import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vkn_charities/main.dart';
import 'package:vkn_charities/pages/about_page.dart';
import 'package:vkn_charities/pages/get_involved_page.dart';
import 'package:vkn_charities/pages/usa_page.dart';
import 'package:vkn_charities/theme.dart';

const _sizes = [Size(1440, 900), Size(900, 1000), Size(390, 844)];

void _setSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  for (final size in _sizes) {
    testWidgets('Home renders without layout errors at ${size.width.toInt()}px', (tester) async {
      _setSize(tester, size);
      await tester.pumpWidget(const VknApp());
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('VKN CHARITIES'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  // Inner pages (hero artwork + sections). Programmes page is skipped: it calls the API.
  final pages = <String, Widget>{
    'About': const AboutPage(),
    'USA': const UsaPage(),
    'Get Involved': const GetInvolvedPage(),
  };
  for (final entry in pages.entries) {
    for (final size in _sizes) {
      testWidgets('${entry.key} renders without layout errors at ${size.width.toInt()}px', (tester) async {
        _setSize(tester, size);
        await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: Scaffold(body: entry.value)));
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull);
      });
    }
  }
}
