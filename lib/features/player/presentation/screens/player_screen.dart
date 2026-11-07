import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/widgets/cover_image.dart';

/// Экран полноэкранного музыкального плеера («Большой плеер»).
///
/// Пока воспроизведение не реализовано, экран показывает выбранный трек
/// и даёт возможность закрыть плеер.
class PlayerScreen extends StatelessWidget {
  /// Текущий воспроизводимый трек.
  final Track? track;

  static const double _maxCoverSize = 360.0;

  const PlayerScreen({
    super.key,
    this.track,
  });

  @override
  Widget build(BuildContext context) {
    final track = this.track;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Экран открывается слайдом снизу поверх нижней панели, поэтому
            // без явной кнопки закрытия на iOS из него невозможно выйти.
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32.0),
              color: AppColors.textPrimary,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
            ),
            if (track != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Квадратная обложка не шире _maxCoverSize; при нехватке
                      // высоты (ландшафт) уменьшается, а не переполняет экран.
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxCoverSize,
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: CoverImage(
                              url: track.coverUrl,
                              cacheSize: _maxCoverSize,
                              iconSize: 64.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        track.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
