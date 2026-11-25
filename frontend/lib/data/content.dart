import 'package:flutter/material.dart';

/// Maps icon keys stored in Supabase (`programs.icon`) to Material icons.
const Map<String, IconData> iconMap = {
  'spa': Icons.spa_outlined,
  'self_improvement': Icons.self_improvement,
  'eco': Icons.eco_outlined,
  'healing': Icons.healing_outlined,
  'elderly': Icons.elderly,
  'child_care': Icons.child_care,
  'school': Icons.school_outlined,
  'park': Icons.park_outlined,
  'volunteer': Icons.volunteer_activism_outlined,
};

IconData iconFor(String? key) => iconMap[key] ?? Icons.spa_outlined;

class Program {
  const Program({
    required this.slug,
    required this.title,
    required this.category,
    required this.summary,
    this.location,
    this.icon = 'spa',
  });

  final String slug;
  final String title;
  final String category;
  final String summary;
  final String? location;
  final String icon;

  factory Program.fromJson(Map<String, dynamic> j) => Program(
        slug: j['slug'] as String? ?? '',
        title: j['title'] as String? ?? '',
        category: j['category'] as String? ?? '',
        summary: j['summary'] as String? ?? '',
        location: j['location'] as String?,
        icon: j['icon'] as String? ?? 'spa',
      );
}

const List<Program> fallbackPrograms = [
  Program(
      slug: 'holistic-healing',
      title: 'Holistic Healing Centres',
      category: 'Healing',
      icon: 'spa',
      location: 'Puravipalayam, Pollachi',
      summary:
          'Integrated care that brings together traditional and complementary therapies to support the whole person — body, mind and spirit.'),
  Program(
      slug: 'yoga-meditation',
      title: 'Yoga & Meditation Retreats',
      category: 'Wellbeing',
      icon: 'self_improvement',
      location: 'Coimbatore & Pollachi',
      summary:
          'Guided yoga, pranayama and meditation sessions and retreats for stress relief, inner balance and healthy living.'),
  Program(
      slug: 'ayurveda-siddha',
      title: 'Ayurveda & Siddha',
      category: 'Healing',
      icon: 'eco',
      location: 'Tamil Nadu',
      summary:
          "Awareness and access to India's time-honoured systems of medicine, including Tamil Nadu's own Siddha tradition."),
  Program(
      slug: 'alternative-therapies',
      title: 'Alternative Therapies',
      category: 'Healing',
      icon: 'healing',
      location: 'Tamil Nadu',
      summary:
          'Natural and complementary treatment approaches offered alongside guidance on healthy lifestyle and diet.'),
  Program(
      slug: 'elder-care',
      title: 'Care for Orphaned Elders',
      category: 'Care',
      icon: 'elderly',
      location: 'Coimbatore',
      summary:
          'Shelter, companionship, nutrition and health support for elderly people who have no one to care for them.'),
  Program(
      slug: 'children',
      title: 'Care for Orphaned Children',
      category: 'Care',
      icon: 'child_care',
      location: 'Coimbatore',
      summary:
          'A safe, loving environment for children in need, with food, health care and a foundation for the future.'),
  Program(
      slug: 'education',
      title: 'Education',
      category: 'Education',
      icon: 'school',
      location: 'Tamil Nadu',
      summary:
          'Learning support and value-based education that helps children and young people build a better future.'),
  Program(
      slug: 'relief-recharge',
      title: 'Relief & Recharge Centres',
      category: 'Wellbeing',
      icon: 'park',
      location: 'Planned',
      summary: 'Calm spaces where people can rest, restore and recover their energy and wellbeing.'),
];
