import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/pressable.dart';
import '../../theme/app_colors.dart';

/// Базовый каркас приложения (Shell Route).
///
/// Содержит активный экран навигации ([navigationShell]) и нижнюю панель вкладок.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  /// Вкладки в порядке веток [StatefulShellRoute].
  static const _tabs = [
    (icon: Icons.home_rounded, label: 'Главная'),
    (icon: Icons.search_rounded, label: 'Поиск'),
    (icon: Icons.library_music_rounded, label: 'Медиатека'),
    (icon: Icons.person_rounded, label: 'Профиль'),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Повторное нажатие на активную вкладку возвращает её к корневому экрану.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: ColoredBox(
        color: AppColors.background,
        child: SafeArea(
          top: false,
          // Панель фиксированной высоты: подписи масштабируются не более чем
          // в 1.3 раза (как в стандартном BottomNavigationBar), иначе при
          // крупном системном шрифте они не помещаются.
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: SizedBox(
              height: 58,
              child: Row(
                children: [
                  for (final (index, tab) in _tabs.indexed)
                    Expanded(
                      child: _NavBarItem(
                        icon: tab.icon,
                        label: tab.label,
                        isSelected: navigationShell.currentIndex == index,
                        onTap: () => _onTap(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Интерактивный элемент нижней панели навигации с микроанимацией нажатия (scale feedback).
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.textPrimary : AppColors.textSecondary;

    return Semantics(
      selected: isSelected,
      child: Pressable(
        onTap: onTap,
        builder: (context, isPressed) => AnimatedScale(
          scale: isPressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeInOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4.0),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
