import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';

/// Экран полноэкранного музыкального плеера («Большой плеер»).
class PlayerScreen extends StatefulWidget {
  /// Текущий воспроизводимый трек.
  final Track? track;

  const PlayerScreen({
    super.key,
    this.track,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox.expand(),
    );
  }
}
