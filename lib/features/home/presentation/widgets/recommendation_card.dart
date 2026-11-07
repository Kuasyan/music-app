import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';

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
class RecommendationCard extends StatefulWidget {
  /// Модель музыкального трека или релиза.
  final Track track;

  /// Обработчик нажатия на карточку.
  final VoidCallback? onTap;

  /// Размер квадратной обложки (ширина и высота).
  final double size;

  /// Стиль отображения текстовых метаданных.
  final CardMetadataStyle metadataStyle;

  /// Стандартный размер обложки по умолчанию.
  static const double cardSize = 150.0;
  static const double defaultSize = cardSize;

  /// Радиус скругления углов обложки.
  static const double borderRadius = 4.0;

  const RecommendationCard({
    super.key,
    required this.track,
    this.onTap,
    this.size = defaultSize,
    this.metadataStyle = CardMetadataStyle.standard,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  bool _isPressed = false;
  DateTime? _pressStartTime;

  void _handleTapDown(TapDownDetails _) {
    _pressStartTime = DateTime.now();
    setState(() => _isPressed = true);
  }

  Future<void> _handleTapUp(TapUpDetails _) async {
    final startTime = _pressStartTime;
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime);
      const minFeedbackDuration = Duration(milliseconds: 140);
      if (elapsed < minFeedbackDuration) {
        await Future.delayed(minFeedbackDuration - elapsed);
      }
    }

    if (mounted) {
      setState(() => _isPressed = false);
    }
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: widget.size,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      RecommendationCard.borderRadius,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.track.coverUrl,
                          fit: BoxFit.cover,
                          memCacheWidth: 300,
                          memCacheHeight: 300,
                          maxWidthDiskCache: 600,
                          maxHeightDiskCache: 600,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Center(
                              child: Icon(
                                Icons.music_note_rounded,
                                color: Color(0xFF404040),
                                size: 32,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Color(0xFF404040),
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 90),
                          curve: Curves.easeInOut,
                          color: _isPressed
                              ? const Color(0x40000000)
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.metadataStyle != CardMetadataStyle.none) ...[
                  const SizedBox(height: 8.0),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.easeInOut,
                    opacity: _isPressed ? 0.55 : 1.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.metadataStyle == CardMetadataStyle.compact) ...[
                          Text(
                            widget.track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '${widget.track.type} • ${widget.track.artist}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFA7A7A7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ] else if (widget.metadataStyle == CardMetadataStyle.standard) ...[
                          Text(
                            widget.track.type,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFA7A7A7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            widget.track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            widget.track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFA7A7A7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ],
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
}
