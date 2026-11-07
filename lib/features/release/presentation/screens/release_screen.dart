import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';

/// Экран деталей музыкального релиза (альбом, плейлист или сингл).
class ReleaseScreen extends StatefulWidget {
  /// Данные выбранного релиза.
  final Track? track;

  /// Радиус скругления углов обложки.
  static const double coverBorderRadius = 4.0;

  /// Форматирует количество сохранений с разделителями тысяч и корректным склонением слова.
  ///
  /// Примеры: `0 сохранений`, `1 сохранение`, `2 сохранения`, `471 192 сохранения`.
  static String formatSavesCount(int count) {
    final digits = count.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    final formattedNumber = buffer.toString();

    final mod10 = count % 10;
    final mod100 = count % 100;

    final String word;
    if (mod100 >= 11 && mod100 <= 14) {
      word = 'сохранений';
    } else if (mod10 == 1) {
      word = 'сохранение';
    } else if (mod10 >= 2 && mod10 <= 4) {
      word = 'сохранения';
    } else {
      word = 'сохранений';
    }

    return '$formattedNumber $word';
  }

  /// Форматирует общую длительность релиза/плейлиста:
  /// - `10 ч. 45 мин.`, `1 ч. 0 мин.` (если более часа)
  /// - `42 мин.` (если менее часа и ровно минуты)
  /// - `2 мин. 32 сек.` (если менее часа с секундами)
  /// - `22 сек.` (если менее минуты)
  static String formatPlaylistDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours ч. $minutes мин.';
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '$minutes мин. $seconds сек.';
      }
      return '$minutes мин.';
    } else {
      return '$seconds сек.';
    }
  }

  /// Формирует строку метаданных:
  /// - Для плейлистов: `Плейлист • <сохранения> • <длительность>`
  /// - Для альбомов и синглов: `Тип контента • Дата выхода`
  static String formatReleaseMetadata(Track? track) {
    final isPlaylist = track?.releaseType == ReleaseType.playlist;

    if (isPlaylist) {
      final saves = formatSavesCount(track?.savesCount ?? 0);
      final duration = formatPlaylistDuration(
        track?.totalDuration ?? track?.duration ?? const Duration(minutes: 45),
      );
      return 'Плейлист • $saves • $duration';
    }

    final type = (track?.type != null && track!.type.isNotEmpty)
        ? track.type
        : 'Альбом';
    final releaseDate =
        (track?.releaseDate != null && track!.releaseDate!.isNotEmpty)
        ? track.releaseDate!
        : '2024';

    return '$type • $releaseDate';
  }

  /// Демонстрационный список треков для плейлистов.
  /// Каждый трек имеет собственную обложку, уникальное название и имя исполнителя.
  static const List<Track> defaultPlaylistTracks = [
    Track(
      id: 'pl_1',
      type: 'Сингл',
      title: 'Midnight City',
      artist: 'M83',
      coverUrl: 'https://picsum.photos/seed/pl_1/300/300',
    ),
    Track(
      id: 'pl_2',
      type: 'Сингл',
      title: 'Starboy (feat. Daft Punk) [Kygo Remix / Deluxe Edition]',
      artist: 'The Weeknd feat. Daft Punk, Gesaffelstein & Swedish House Mafia',
      coverUrl: 'https://picsum.photos/seed/pl_2/300/300',
    ),
    Track(
      id: 'pl_3',
      type: 'Сингл',
      title: 'Nightcall',
      artist: 'Kavinsky & Lovefoxxx feat. Sebastian Tellier',
      coverUrl: 'https://picsum.photos/seed/pl_3/300/300',
    ),
    Track(
      id: 'pl_4',
      type: 'Сингл',
      title: 'Танцы в Темноте (Special Extended Orchestral Acoustic Live Version)',
      artist: 'Марк Левин feat. Симфонический Оркестр Санкт-Петербурга',
      coverUrl: 'https://picsum.photos/seed/pl_4/300/300',
    ),
    Track(
      id: 'pl_5',
      type: 'Сингл',
      title: 'Resonance',
      artist: 'HOME',
      coverUrl: 'https://picsum.photos/seed/pl_5/300/300',
    ),
    Track(
      id: 'pl_6',
      type: 'Сингл',
      title: 'Холодный Неон (Club Extended VIP Mix / Instrumental Version)',
      artist: 'Эрика feat. Mark Ronson & London Contemporary Voices',
      coverUrl: 'https://picsum.photos/seed/pl_6/300/300',
    ),
    Track(
      id: 'pl_7',
      type: 'Сингл',
      title: 'Sunset Lover',
      artist: 'Petit Biscuit',
      coverUrl: 'https://picsum.photos/seed/pl_7/300/300',
    ),
    Track(
      id: 'pl_8',
      type: 'Сингл',
      title: 'Горизонт Событий: Путешествие сквозь Бесконечность и Время',
      artist: 'Space Orchestra & Philharmonic Electronic Ensemble',
      coverUrl: 'https://picsum.photos/seed/pl_8/300/300',
    ),
    Track(
      id: 'pl_9',
      type: 'Сингл',
      title: 'After Dark',
      artist: 'Mr.Kitty',
      coverUrl: 'https://picsum.photos/seed/pl_9/300/300',
    ),
    Track(
      id: 'pl_10',
      type: 'Сингл',
      title: 'Не Улетай (Slowed + Reverb Radio Edit Bonus Track)',
      artist: 'Даша Котова feat. Acoustic String Quartet & DJ Neo',
      coverUrl: 'https://picsum.photos/seed/pl_10/300/300',
    ),
  ];

  /// Демонстрационный список треков для альбома/сингла (без индивидуальных обложек).
  static List<Track> getDefaultAlbumTracks(String artist) => [
    Track(
      id: 'alb_1',
      type: 'Сингл',
      title: 'Вступление (Intro)',
      artist: artist,
      coverUrl: '',
    ),
    Track(
      id: 'alb_2',
      type: 'Сингл',
      title: 'Холодный Неон',
      artist: artist,
      coverUrl: '',
    ),
    Track(
      id: 'alb_3',
      type: 'Сингл',
      title: 'Огни Большого Города и Бесконечные Неоновые Автострады (Remastered)',
      artist: '$artist feat. Ночные Огни & Симфония Ветра',
      coverUrl: '',
    ),
    Track(
      id: 'alb_4',
      type: 'Сингл',
      title: 'После Полуночи',
      artist: artist,
      coverUrl: '',
    ),
    Track(
      id: 'alb_5',
      type: 'Сингл',
      title: 'Танцы в Темноте под Проливным Дождём (Acoustic Club Mix)',
      artist: '$artist feat. Приглашённые Музыканты & Оркестр',
      coverUrl: '',
    ),
    Track(
      id: 'alb_6',
      type: 'Сингл',
      title: 'Финал (Outro)',
      artist: artist,
      coverUrl: '',
    ),
  ];

  const ReleaseScreen({super.key, this.track});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  /// Доминантный цвет, извлечённый алгоритмически из обложки.
  Color? _dominantColor;

  /// Контроллер скролла для плавной синхронизации анимаций обложки и AppBar.
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _extractDominantColor();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ReleaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track?.coverUrl != widget.track?.coverUrl) {
      _extractDominantColor();
    }
  }

  /// Извлекает ключевой цвет из изображения обложки с помощью встроенного
  /// в Flutter механизма Material 3 [ColorScheme.fromImageProvider].
  Future<void> _extractDominantColor() async {
    final coverUrl = widget.track?.coverUrl;
    if (coverUrl == null || coverUrl.isEmpty) return;

    try {
      final scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(coverUrl),
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      if (mounted) {
        setState(() {
          _dominantColor = scheme.primary;
        });
      }
    } catch (_) {
      // При отсутствии сети или сбое загрузки фон остаётся базовым тёмным.
    }
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = widget.track?.coverUrl;
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;

    // Адаптивный исходный размер обложки:
    // (Ширина экрана - 2 * 60 px = screenWidth - 120.0).
    final coverSize = (screenWidth - 120.0).clamp(180.0, 360.0);

    // Высота распространения градиента: точно до нижнего края кнопки «Слушать»
    // (topPadding + 16 px отступ + обложка + текстовый блок с отступами + 50 px кнопка).
    final gradientHeight = topPadding + coverSize + 168.0;

    // Плавное монотонное смешивание цветов градиента для устранения артефактов и тёмных полос
    final dominant = _dominantColor ?? AppColors.background;
    final gradientTop =
        Color.lerp(dominant, AppColors.background, 0.35) ??
        AppColors.background;
    final gradientMid =
        Color.lerp(dominant, AppColors.background, 0.70) ??
        AppColors.background;

    // Определяем тип релиза и формируем список треков
    final isPlaylist = widget.track?.releaseType == ReleaseType.playlist;
    final trackList =
        (widget.track?.tracks != null && widget.track!.tracks!.isNotEmpty)
            ? widget.track!.tracks!
            : (isPlaylist
                ? ReleaseScreen.defaultPlaylistTracks
                : ReleaseScreen.getDefaultAlbumTracks(
                    widget.track?.artist ?? 'Исполнитель',
                  ));

    // Параметры анимации синхронного скролла:
    final double initialCoverSize = coverSize;
    // Оптимальный минимальный размер сжатой обложки (~52% от исходного, 130–140 dp):
    final double minCoverSize = (initialCoverSize * 0.52).clamp(120.0, 150.0);
    final double initialCoverTop = topPadding + 16.0;

    // Дистанция фазы 1: сжатие обложки при зафиксированном верхнем крае
    final double shrinkDistance = initialCoverSize - minCoverSize;

    // Дистанция фазы 2: уезжание обложки вверх с одновременным исчезновением
    const double fadeDistance = 80.0;

    // Дистанция фазы 3: плавное появление верхнего AppBar
    const double appBarFadeDistance = 35.0;

    final double appBarHeight = topPadding + 56.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final scrollOffset = _scrollController.hasClients
              ? _scrollController.offset
              : 0.0;

          final double overscroll = scrollOffset < 0.0 ? -scrollOffset : 0.0;

          final double currentCoverSize;
          final double coverTop;
          final double coverOpacity;
          final double appBarOpacity;
          final double backButtonTop;

          if (scrollOffset <= 0.0) {
            // В самом верху или оверскролл вниз (пружинящий отскок)
            currentCoverSize = initialCoverSize;
            coverTop = initialCoverTop + overscroll;
            coverOpacity = 1.0;
            appBarOpacity = 0.0;
            backButtonTop = topPadding + 4.0 + overscroll;
          } else if (scrollOffset <= shrinkDistance) {
            // Фаза 1: Верх обложки зафиксирован, обложка уменьшается синхронно со скроллом
            final double t = (scrollOffset / shrinkDistance).clamp(0.0, 1.0);
            currentCoverSize = initialCoverSize - (shrinkDistance * t);
            coverTop = initialCoverTop;
            coverOpacity = 1.0;
            appBarOpacity = 0.0;
            backButtonTop = topPadding + 4.0;
          } else if (scrollOffset <= shrinkDistance + fadeDistance) {
            // Фаза 2: Обложка достигла минимума, уезжает вверх и синхронно исчезает
            final double extra = scrollOffset - shrinkDistance;
            final double t = (extra / fadeDistance).clamp(0.0, 1.0);
            currentCoverSize = minCoverSize;
            coverTop = initialCoverTop - extra;
            coverOpacity = (1.0 - t).clamp(0.0, 1.0);
            appBarOpacity = 0.0;
            backButtonTop = topPadding + 4.0;
          } else {
            // Фаза 3: Обложка исчезла, плавно появляется верхний AppBar
            currentCoverSize = minCoverSize;
            coverTop = initialCoverTop - fadeDistance;
            coverOpacity = 0.0;
            final double pastFade =
                scrollOffset - (shrinkDistance + fadeDistance);
            appBarOpacity = (pastFade / appBarFadeDistance).clamp(0.0, 1.0);
            backButtonTop = topPadding + 4.0;
          }

          return Stack(
            children: [
              // 0. Фоновая заливка цвета темы при оверскролле вниз (устраняет чёрное пространство над контентом)
              if (scrollOffset < 0.0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: -scrollOffset + topPadding + 100.0,
                  child: Container(
                    color: gradientTop,
                  ),
                ),

              // 1. Скроллируемая область: фоновый градиент и контент
              SingleChildScrollView(
                controller: _scrollController,
                clipBehavior: Clip.none,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: _TightBouncingScrollPhysics(),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Бесшовная верхняя заливка цвета темы для оверскролла:
                    // когда экран оттягивается вниз, пространство над градиентом остаётся в цвет темы
                    Positioned(
                      top: -1000.0,
                      left: 0,
                      right: 0,
                      height: 1000.0,
                      child: AnimatedOpacity(
                        opacity: _dominantColor != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: Container(
                          color: gradientTop,
                        ),
                      ),
                    ),

                    // Фоновый градиент, привязанный к обложке и скроллящийся вместе с ней
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: gradientHeight,
                      child: AnimatedOpacity(
                        opacity: _dominantColor != null ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                gradientTop,
                                gradientMid,
                                AppColors.background,
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Основной контент релиза
                    Padding(
                      padding: EdgeInsets.only(
                        top: topPadding + 16.0,
                        bottom: 32.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Невидимый заполнитель пространства исходного размера обложки:
                          // контент под ним скроллится синхронно с нижней гранью уменьшающейся обложки
                          SizedBox(
                            width: double.infinity,
                            height: initialCoverSize,
                          ),

                          // Отступ 16 px между обложкой и названием контента
                          const SizedBox(height: 16.0),

                          // Название контента: отступы по 16 px слева и справа, максимум 2 строки с многоточием
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              widget.track?.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.4,
                                height: 1.25,
                              ),
                            ),
                          ),

                          // Отступ 8 px между названием контента и исполнителем
                          const SizedBox(height: 8.0),

                          // Имя исполнителя: отступы по 16 px слева и справа
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              widget.track?.artist ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                                height: 1.3,
                              ),
                            ),
                          ),

                          // Отступ 8 px между именем исполнителя и метаданными релиза
                          const SizedBox(height: 8.0),

                          // Метаданные релиза: тип контента, дата выхода или сохранения и длительность плейлиста
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              ReleaseScreen.formatReleaseMetadata(widget.track),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFFA7A7A7),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),

                          // Отступ 16 px от строки метаданных до кнопки «Слушать»
                          const SizedBox(height: 16.0),

                          // Кнопка воспроизведения «Слушать»: на всю ширину с боковыми отступами 16 px
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50.0,
                              child: FilledButton.icon(
                                onPressed: () {
                                  if (trackList.isNotEmpty) {
                                    final firstTrack =
                                        trackList.first.coverUrl.isNotEmpty
                                            ? trackList.first
                                            : Track(
                                                id: trackList.first.id,
                                                title: trackList.first.title,
                                                artist: trackList.first.artist,
                                                coverUrl:
                                                    widget.track?.coverUrl ??
                                                        '',
                                                type: widget.track?.type ??
                                                    'Альбом',
                                              );
                                    context.push('/player', extra: firstTrack);
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.textPrimary,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 24.0,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Слушать',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Отступ 16 px от кнопки «Слушать» до списка треков
                          const SizedBox(height: 16.0),

                          // Список треков релиза: отступы по 16 px слева и справа
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i = 0; i < trackList.length; i++) ...[
                                  if (i > 0) const SizedBox(height: 12.0),
                                  _TrackTile(
                                    track: trackList[i],
                                    showCover: isPlaylist,
                                    onTap: () {
                                      final playerTrack =
                                          trackList[i].coverUrl.isNotEmpty
                                              ? trackList[i]
                                              : Track(
                                                  id: trackList[i].id,
                                                  title: trackList[i].title,
                                                  artist: trackList[i].artist,
                                                  coverUrl:
                                                      widget.track?.coverUrl ??
                                                          '',
                                                  type: widget.track?.type ??
                                                      'Альбом',
                                                );
                                      context.push('/player', extra: playerTrack);
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Плавающая обложка релиза:
              // При скролле верх зафиксирован, обложка уменьшается, затем уезжает вверх и исчезает
              if (coverOpacity > 0.0)
                Positioned(
                  top: coverTop,
                  left: (screenWidth - currentCoverSize) / 2,
                  width: currentCoverSize,
                  height: currentCoverSize,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: coverOpacity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          ReleaseScreen.coverBorderRadius,
                        ),
                        child: coverUrl != null && coverUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: coverUrl,
                                fit: BoxFit.cover,
                                memCacheWidth: (initialCoverSize * 2).round(),
                                memCacheHeight: (initialCoverSize * 2).round(),
                                placeholder: (context, url) => Container(
                                  color: const Color(0xFF1E1E1E),
                                  child: const Center(
                                    child: Icon(
                                      Icons.music_note_rounded,
                                      color: Color(0xFF404040),
                                      size: 48,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Container(
                                      color: const Color(0xFF1E1E1E),
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image_rounded,
                                          color: Color(0xFF404040),
                                          size: 48,
                                        ),
                                      ),
                                    ),
                              )
                            : Container(
                                color: const Color(0xFF1E1E1E),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note_rounded,
                                    color: Color(0xFF404040),
                                    size: 48,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

              // 3. Верхний AppBar: фоновая подложка цвета темы
              if (appBarOpacity > 0.0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: appBarHeight,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: appBarOpacity,
                      child: Container(
                        decoration: BoxDecoration(
                          color: gradientTop,
                          boxShadow: [
                            if (appBarOpacity > 0.8)
                              const BoxShadow(
                                color: Color(0x59000000),
                                blurRadius: 8.0,
                                offset: Offset(0, 2),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. Верхний AppBar: название релиза по центру (появляется синхронно с фоном)
              if (appBarOpacity > 0.0)
                Positioned(
                  top: topPadding,
                  left: 56.0,
                  right: 56.0,
                  height: 56.0,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: appBarOpacity,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.track?.title ?? '',
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 5. Кнопка «Назад»: зафиксирована поверх всех слоёв, при оверскролле смещается вместе с обложкой
              Positioned(
                top: backButtonTop,
                left: 6.0,
                child: _ReleaseBackButton(
                  onTap: () {
                    if (!context.mounted) return;
                    try {
                      context.pop();
                    } catch (_) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Настраиваемая упругая физика скролла с высоким сопротивлением оверскролла.
///
/// В отличие от стандартного BouncingScrollPhysics (где коэффициент трения 0.52),
/// здесь коэффициент уменьшен до 0.10, что даёт ощутимое упругое сопротивление
/// и позволяет оттянуть экран сверху вниз лишь на небольшое контролируемое
/// расстояние (~20-25 px), в точности как на экране «Главная».
class _TightBouncingScrollPhysics extends BouncingScrollPhysics {
  const _TightBouncingScrollPhysics({super.parent});

  @override
  _TightBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _TightBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double frictionFactor(double overscrollFraction) {
    return 0.10 * math.pow(1.0 - overscrollFraction.clamp(0.0, 1.0), 3.0);
  }
}

/// Интерактивная кнопка возврата («Назад») с тактильным откликом при нажатии и удержании.
///
/// При нажатии и зажатии плавно сжимается ([AnimatedScale] со значением 0.88, в точности
/// как иконки в нижнем баре навигации) и мягко затемняется с помощью наложения
/// [Color(0x40000000)] (в точности как эффект затемнения обложки при зажатии на Главной),
/// сохраняя стабильную невидимую хит-зону 48x48.
class _ReleaseBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ReleaseBackButton({required this.onTap});

  @override
  State<_ReleaseBackButton> createState() => _ReleaseBackButtonState();
}

class _ReleaseBackButtonState extends State<_ReleaseBackButton> {
  bool _isPressed = false;
  DateTime? _pressStartTime;

  /// Исходный цвет стрелки (белый).
  static const Color _defaultColor = AppColors.textPrimary;

  /// Цвет стрелки при зажатии: затемнение на 25% (наложение Color(0x40000000) поверх белого,
  /// в точности аналогично эффекту затемнения обложки при зажатии на Главной).
  static final Color _pressedColor = Color.alphaBlend(
    const Color(0x40000000),
    AppColors.textPrimary,
  );

  void _handleTapDown(TapDownDetails _) {
    _pressStartTime = DateTime.now();
    setState(() => _isPressed = true);
  }

  Future<void> _handleTapUp(TapUpDetails _) async {
    final startTime = _pressStartTime;
    if (startTime != null) {
      final elapsed = DateTime.now().difference(startTime);
      const minFeedbackDuration = Duration(milliseconds: 100);
      if (elapsed < minFeedbackDuration) {
        await Future.delayed(minFeedbackDuration - elapsed);
      }
    }

    if (mounted) {
      setState(() => _isPressed = false);
    }
    widget.onTap();
  }

  void _handleTapCancel() {
    if (mounted) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: Center(
          child: AnimatedScale(
            scale: _isPressed ? 0.88 : 1.0,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeInOut,
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: _isPressed ? _pressedColor : _defaultColor,
              ),
              duration: const Duration(milliseconds: 110),
              curve: Curves.easeInOut,
              builder: (context, color, child) {
                return Icon(
                  Icons.arrow_back_rounded,
                  size: 28.0,
                  color: color,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Элемент списка треков на экране релиза.
class _TrackTile extends StatefulWidget {
  /// Данные трека.
  final Track track;

  /// Показывать ли обложку (для плейлистов — true, для альбомов и синглов — false).
  final bool showCover;

  /// Обработчик нажатия на трек.
  final VoidCallback onTap;

  const _TrackTile({
    required this.track,
    required this.showCover,
    required this.onTap,
  });

  @override
  State<_TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<_TrackTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeInOut,
        opacity: _isPressed ? 0.6 : 1.0,
        child: Row(
          children: [
            if (widget.showCover) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: SizedBox(
                  width: 48.0,
                  height: 48.0,
                  child: widget.track.coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.track.coverUrl,
                          fit: BoxFit.cover,
                          memCacheWidth: 96,
                          memCacheHeight: 96,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Center(
                              child: Icon(
                                Icons.music_note_rounded,
                                color: Color(0xFF404040),
                                size: 22.0,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF1E1E1E),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Color(0xFF404040),
                                size: 22.0,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: const Color(0xFF1E1E1E),
                          child: const Center(
                            child: Icon(
                              Icons.music_note_rounded,
                              color: Color(0xFF404040),
                              size: 22.0,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12.0),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    widget.track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFA7A7A7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
