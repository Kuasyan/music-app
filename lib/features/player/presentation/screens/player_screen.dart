import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/widgets/pressable.dart';

/// Экран полноэкранного музыкального плеера («Большой плеер»).
///
/// На данном этапе экран содержит только стрелку закрытия (сворачивания);
/// остальные элементы управления будут добавляться пошагово.
class PlayerScreen extends StatelessWidget {
  /// Текущий воспроизводимый трек.
  final Track? track;

  /// Отступ кнопки закрытия сверху от границы статус-бара (как на экране Release).
  static const double backButtonTopOffset = 4.0;

  /// Отступ кнопки закрытия слева от края экрана (как на экране Release).
  static const double backButtonLeftOffset = 6.0;

  /// Размер хит-зоны кнопки закрытия по стандартам Google (48x48 dp).
  static const double backButtonTouchTarget = 48.0;

  const PlayerScreen({
    super.key,
    this.track,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: topPadding + backButtonTopOffset,
            left: backButtonLeftOffset,
            child: _PlayerCloseButton(
              onTap: () => Navigator.maybePop(context),
            ),
          ),
        ],
      ),
    );
  }
}

/// Кнопка закрытия («Назад») большого плеера.
///
/// Имеет невидимые границы 48x48 dp по стандартам Google (WCAG / Material Target Size),
/// расположена на тех же координатах, что и стрелка возврата на экране Release,
/// и поддерживает плавный тактильный отклик при нажатии.
class _PlayerCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _PlayerCloseButton({required this.onTap});

  static final Color _pressedColor = Color.alphaBlend(
    AppColors.pressedOverlay,
    AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: PlayerScreen.backButtonTouchTarget,
      child: Semantics(
        label: MaterialLocalizations.of(context).closeButtonTooltip,
        child: Pressable(
          onTap: onTap,
          minPressedDuration: const Duration(milliseconds: 100),
          builder: (context, isPressed) => Center(
            child: AnimatedScale(
              scale: isPressed ? 0.88 : 1.0,
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeInOut,
              child: TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  end: isPressed ? _pressedColor : AppColors.textPrimary,
                ),
                duration: const Duration(milliseconds: 110),
                curve: Curves.easeInOut,
                builder: (context, color, child) => Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 32.0,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
