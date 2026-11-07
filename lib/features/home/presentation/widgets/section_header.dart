import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// Типографический заголовок секции контента.
class SectionHeader extends StatelessWidget {
  /// Текст заголовка.
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTypography.sectionTitle);
  }
}
