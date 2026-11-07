import 'package:flutter/material.dart';

/// Палитра цветов дизайн-системы приложения.
abstract final class AppColors {
  /// Основной фон экранов и подложек.
  static const Color background = Color(0xFF121212);

  /// Фон приподнятых элементов: заглушки обложек, плашки иконок.
  static const Color surface = Color(0xFF1E1E1E);

  /// Основной цвет текста и акцентных элементов.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Вторичный цвет текста и неактивных иконок (описания, подписи авторов).
  static const Color textSecondary = Color(0xFFA7A7A7);

  /// Цвет иконок-заглушек на фоне [surface].
  static const Color placeholderIcon = Color(0xFF404040);

  /// Затемнение элемента в нажатом состоянии.
  static const Color pressedOverlay = Color(0x40000000);
}
