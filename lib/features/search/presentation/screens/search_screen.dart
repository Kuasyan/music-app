import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_screen.dart';

/// Экран глобального поиска по каталогу музыки.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      icon: Icons.search_rounded,
      title: 'Поиск в разработке',
      description: 'Здесь появится поиск по трекам, альбомам, плейлистам и исполнителям.',
    );
  }
}
