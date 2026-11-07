import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_screen.dart';

/// Экран профиля и настроек пользователя.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      icon: Icons.person_rounded,
      title: 'Профиль в разработке',
      description: 'Управление аккаунтом Supabase, качество аудио и настройки стриминга.',
    );
  }
}
