import 'package:flutter/material.dart';

/// Палитра цветов дизайн-системы приложения.
abstract final class AppColors {
  /// Основной фон экранов и подложек.
  static const Color background = Color(0xFF121212);

  /// Основной цвет текста и акцентных элементов.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Вторичный цвет текста (описания, подписи авторов).
  static const Color textSecondary = Color(0xFFB3B3B3);

  /// Приглушённый цвет текста для второстепенных метаданных.
  static const Color textMuted = Color(0xFF717171);
}
