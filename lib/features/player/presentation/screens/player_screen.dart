import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';

/// Экран полноэкранного музыкального плеера («Большой плеер»).
///
/// На данном этапе экран содержит только кнопку со стрелкой закрытия;
/// наполнение плеера будет формироваться пошагово.
class PlayerScreen extends StatelessWidget {
  /// Текущий воспроизводимый трек.
  final Track? track;

  const PlayerScreen({
    super.key,
    this.track,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4.0),
            child: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32.0),
              color: AppColors.textPrimary,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
      ),
    );
  }
}
