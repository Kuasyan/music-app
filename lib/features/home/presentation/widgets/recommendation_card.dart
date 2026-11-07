import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/widgets/cover_image.dart';
import '../../../../shared/widgets/pressable.dart';

/// Варианты компоновки текстовых метаданных под обложкой карточки.
enum CardMetadataStyle {
  /// Трёхстрочный формат: Тип релиза -> Название -> Исполнитель.
  standard,

  /// Двухстрочный компактный формат: Название -> Тип • Исполнитель.
  compact,

  /// Только обложка без текстовых подписей.
  none,
}

/// Карточка музыкального релиза с сетевой обложкой, кэшированием и интерактивным откликом.
class RecommendationCard extends StatelessWidget {
  /// Модель музыкального трека или релиза.
  final Track track;

  /// Обработчик нажатия на карточку.
  final VoidCallback? onTap;

  /// Размер квадратной обложки (ширина и высота).
  final double size;

  /// Стиль отображения текстовых метаданных.
  final CardMetadataStyle metadataStyle;

  /// Стандартный размер обложки по умолчанию.
  static const double defaultSize = 150.0;

  /// Радиус скругления углов обложки.
  static const double borderRadius = 4.0;

  /// Отступ между обложкой и текстовыми метаданными.
  static const double _metadataGap = 8.0;

  /// Интервал между строками метаданных.
  static const double _lineGap = 2.0;

  const RecommendationCard({
    super.key,
    required this.track,
    this.onTap,
    this.size = defaultSize,
    this.metadataStyle = CardMetadataStyle.standard,
  });

  /// Высота блока метаданных под обложкой с учётом системного масштаба шрифта.
  ///
  /// Нужна горизонтальным спискам, которым требуется фиксированная высота.
  static double metadataHeight(
    CardMetadataStyle style,
    TextScaler textScaler,
  ) {
    // Движок округляет высоту строки абзаца вверх до целого пикселя.
    double lineHeight(TextStyle s) =>
        (textScaler.scale(s.fontSize!) * s.height!).ceilToDouble();

    final title = lineHeight(AppTypography.cardTitle);
    final subtitle = lineHeight(AppTypography.cardSubtitle);

    return switch (style) {
      CardMetadataStyle.standard =>
        _metadataGap + subtitle + _lineGap + title + _lineGap + subtitle,
      CardMetadataStyle.compact => _metadataGap + title + _lineGap + subtitle,
      CardMetadataStyle.none => 0.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Pressable(
        onTap: onTap,
        minPressedDuration: const Duration(milliseconds: 140),
        builder: (context, isPressed) => AnimatedScale(
          scale: isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: size,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  width: size,
                  height: size,
                  duration: const Duration(milliseconds: 90),
                  curve: Curves.easeInOut,
                  foregroundDecoration: BoxDecoration(
                    color: isPressed
                        ? AppColors.pressedOverlay
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: CoverImage(
                    url: track.coverUrl,
                    cacheSize: size,
                    borderRadius: borderRadius,
                  ),
                ),
                if (metadataStyle != CardMetadataStyle.none) ...[
                  const SizedBox(height: _metadataGap),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.easeInOut,
                    opacity: isPressed ? 0.55 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildMetadataLines(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMetadataLines() {
    Widget line(String text, TextStyle style) => Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        );

    return switch (metadataStyle) {
      CardMetadataStyle.standard => [
          line(track.type.label, AppTypography.cardSubtitle),
          const SizedBox(height: _lineGap),
          line(track.title, AppTypography.cardTitle),
          const SizedBox(height: _lineGap),
          line(track.artist, AppTypography.cardSubtitle),
        ],
      CardMetadataStyle.compact => [
          line(track.title, AppTypography.cardTitle),
          const SizedBox(height: _lineGap),
          line(
            '${track.type.label} • ${track.artist}',
            AppTypography.cardSubtitle,
          ),
        ],
      CardMetadataStyle.none => const [],
    };
  }
}
