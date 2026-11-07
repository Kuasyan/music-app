import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_screen.dart';

/// Экран медиатеки пользователя (сохранённые плейлисты, история, избранное).
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      icon: Icons.library_music_rounded,
      title: 'Медиатека в разработке',
      description: 'Здесь будут сохраненные треки, альбомы, плейлисты и исполнители.',
    );
  }
}
