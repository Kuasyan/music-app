import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Типографика приложения.
abstract final class AppTypography {
  /// Стиль заголовков секций контента.
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.2,
  );
}
