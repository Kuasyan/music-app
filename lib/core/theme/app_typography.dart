import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Типографика приложения.
///
/// У стилей, участвующих в расчёте фиксированных высот, явно задан [TextStyle.height],
/// чтобы высота строки не зависела от метрик конкретного шрифта.
abstract final class AppTypography {
  /// Стиль заголовков секций контента.
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Основная строка карточки релиза (название).
  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.2,
  );

  /// Вторичная строка карточки релиза (тип, исполнитель).
  static const TextStyle cardSubtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.2,
  );
}
