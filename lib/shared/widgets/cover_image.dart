import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Обложка трека или релиза с кэшированием, заглушкой и обработкой ошибок.
///
/// Занимает всё пространство, выделенное родителем. Размер декодируемого
/// изображения рассчитывается из [cacheSize] с учётом плотности пикселей экрана,
/// поэтому обложка остаётся чёткой на любых дисплеях и не тратит лишнюю память.
class CoverImage extends StatelessWidget {
  /// URL изображения. Пустая строка означает отсутствие обложки.
  final String url;

  /// Наибольший логический размер, в котором будет показана обложка.
  ///
  /// Должен быть стабильным: при анимированном изменении размера передавайте
  /// максимальное значение, иначе изображение будет декодироваться заново.
  final double cacheSize;

  /// Радиус скругления углов.
  final double borderRadius;

  /// Размер иконки-заглушки.
  final double iconSize;

  const CoverImage({
    super.key,
    required this.url,
    required this.cacheSize,
    this.borderRadius = 4.0,
    this.iconSize = 32.0,
  });

  Widget _placeholder(IconData icon) {
    return ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Icon(icon, color: AppColors.placeholderIcon, size: iconSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cachePixels =
        (cacheSize * MediaQuery.devicePixelRatioOf(context)).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: url.isEmpty
          ? _placeholder(Icons.music_note_rounded)
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              memCacheWidth: cachePixels,
              memCacheHeight: cachePixels,
              placeholder: (context, url) =>
                  _placeholder(Icons.music_note_rounded),
              errorWidget: (context, url, error) =>
                  _placeholder(Icons.broken_image_rounded),
            ),
    );
  }
}
