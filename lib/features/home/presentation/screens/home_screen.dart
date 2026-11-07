import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';
import '../../data/mock_home_data.dart';
import '../widgets/horizontal_section.dart';
import '../widgets/recommendation_card.dart';

/// Главный экран приложения.
///
/// Отображает подборки треков, разбитые по горизонтальным секциям:
/// рекомендации, недавно воспроизведённые и новые релизы.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Вертикальный интервал между секциями контента.
  static const double sectionSpacing = 32.0;

  void _openRelease(BuildContext context, Track track) {
    context.push(AppRoutes.release(track.id), extra: track);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendedTracksProvider);
    final recentlyPlayed = ref.watch(recentlyPlayedProvider);
    final newReleases = ref.watch(newReleasesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HorizontalSection(
                  title: 'Рекомендации',
                  tracks: recommendations,
                  metadataStyle: CardMetadataStyle.standard,
                  onTrackTap: (track) => _openRelease(context, track),
                ),
                const SizedBox(height: sectionSpacing),
                HorizontalSection(
                  title: 'Недавние',
                  tracks: recentlyPlayed,
                  cardSize: 100.0,
                  metadataStyle: CardMetadataStyle.compact,
                  onTrackTap: (track) => _openRelease(context, track),
                ),
                const SizedBox(height: sectionSpacing),
                HorizontalSection(
                  title: 'Новые релизы',
                  tracks: newReleases,
                  metadataStyle: CardMetadataStyle.standard,
                  onTrackTap: (track) => _openRelease(context, track),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
