import 'package:flutter/material.dart';

import '../../../../shared/models/track.dart';
import 'recommendation_card.dart';
import 'section_header.dart';

/// Горизонтальная прокручиваемая секция карточек треков с заголовком.
class HorizontalSection extends StatelessWidget {
  /// Заголовок секции.
  final String title;

  /// Список треков для отображения.
  final List<Track> tracks;

  /// Коллбэк при нажатии на карточку трека.
  final void Function(Track track)? onTrackTap;

  /// Размер квадратной обложки карточки.
  final double cardSize;

  /// Стиль отображения метаданных под обложкой.
  final CardMetadataStyle metadataStyle;

  const HorizontalSection({
    super.key,
    required this.title,
    required this.tracks,
    this.onTrackTap,
    this.cardSize = RecommendationCard.defaultSize,
    this.metadataStyle = CardMetadataStyle.standard,
  });

  @override
  Widget build(BuildContext context) {
    final double extraHeight = switch (metadataStyle) {
      CardMetadataStyle.standard => 66.0,
      CardMetadataStyle.compact => 46.0,
      CardMetadataStyle.none => 0.0,
    };

    final sectionHeight = cardSize + extraHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SectionHeader(title: title),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: sectionHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: tracks.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16.0),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return RecommendationCard(
                track: track,
                size: cardSize,
                metadataStyle: metadataStyle,
                onTap: () => onTrackTap?.call(track),
              );
            },
          ),
        ),
      ],
    );
  }
}
