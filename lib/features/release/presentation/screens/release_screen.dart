import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/track.dart';
import '../../../../shared/widgets/cover_image.dart';
import '../../../../shared/widgets/pressable.dart';
import '../release_formatters.dart';

/// Экран деталей музыкального релиза (альбом, плейлист или сингл).
class ReleaseScreen extends StatefulWidget {
  /// Данные выбранного релиза.
  final Track track;

  /// Радиус скругления углов обложки.
  static const double coverBorderRadius = 4.0;

  const ReleaseScreen({super.key, required this.track});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  /// Доминантный цвет, извлечённый алгоритмически из обложки.
  Color? _dominantColor;

  /// Контроллер скролла для плавной синхронизации анимаций обложки и AppBar.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    if (oldWidget.track.coverUrl != widget.track.coverUrl) {
      _dominantColor = null;
      _extractDominantColor();
    }
  }

  /// Извлекает ключевой цвет из изображения обложки с помощью встроенного
  /// в Flutter механизма Material 3 [ColorScheme.fromImageProvider].
  Future<void> _extractDominantColor() async {
    final coverUrl = widget.track.coverUrl;
    if (coverUrl.isEmpty) return;

    try {
      final scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(coverUrl),
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      );
      // Пока цвет вычислялся, экран мог закрыться или получить другой релиз.
      if (mounted && widget.track.coverUrl == coverUrl) {
        setState(() => _dominantColor = scheme.primary);
      }
    } catch (_) {
      // При отсутствии сети или сбое загрузки фон остаётся базовым тёмным.
    }
  }

  /// Открывает плеер. Трекам без собственной обложки подставляется обложка релиза.
  void _openPlayer(Track track) {
    final playerTrack = track.coverUrl.isNotEmpty
        ? track
        : track.copyWith(coverUrl: widget.track.coverUrl);
    context.push(AppRoutes.player, extra: playerTrack);
  }

  @override
  Widget build(BuildContext context) {
    final release = widget.track;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final topPadding = MediaQuery.paddingOf(context).top;

    // Адаптивный исходный размер обложки: по 60 px отступа слева и справа.
    final double initialCoverSize = (screenWidth - 120.0).clamp(180.0, 360.0);

    // Плавное монотонное смешивание цветов градиента для устранения артефактов и тёмных полос
    final dominant = _dominantColor ?? AppColors.background;
    final gradientTop = Color.lerp(dominant, AppColors.background, 0.35)!;
    final gradientMid = Color.lerp(dominant, AppColors.background, 0.70)!;

    final isPlaylist = release.type == ReleaseType.playlist;
    final trackList = release.tracks ?? const <Track>[];

    // Параметры анимации синхронного скролла:
    // оптимальный минимальный размер сжатой обложки (~52% от исходного, 120–150 dp).
    final double minCoverSize = (initialCoverSize * 0.52).clamp(120.0, 150.0);
    final double initialCoverTop = topPadding + 16.0;

    // Дистанция фазы 1: сжатие обложки при зафиксированном верхнем крае
    final double shrinkDistance = initialCoverSize - minCoverSize;

    // Дистанция фазы 2: уезжание обложки вверх с одновременным исчезновением
    const double fadeDistance = 80.0;

    // Дистанция фазы 3: плавное появление верхнего AppBar
    const double appBarFadeDistance = 35.0;

    final double appBarHeight = topPadding + 56.0;

    // Скроллируемый контент не зависит от смещения скролла, поэтому строится
    // один раз и передаётся в AnimatedBuilder как child: на каждом кадре
    // перестраиваются только наложенные слои (обложка, AppBar, кнопка «Назад»).
    final scrollContent = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: _TightScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Фоновый градиент под обложкой и шапкой релиза,
                // заканчивается у нижнего края шапки цветом фона экрана.
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _dominantColor != null ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    child: DecoratedBox(
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
                Padding(
                  padding: EdgeInsets.only(
                    top: initialCoverTop,
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: _ReleaseHeader(
                    release: release,
                    // Невидимый заполнитель исходного размера обложки: сама обложка
                    // рисуется поверх скролла и анимируется отдельно.
                    coverPlaceholderHeight: initialCoverSize,
                    onPlay: trackList.isEmpty
                        ? null
                        : () => _openPlayer(trackList.first),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32.0),
            sliver: SliverList.separated(
              itemCount: trackList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12.0),
              itemBuilder: (context, index) => _TrackTile(
                track: trackList[index],
                showCover: isPlaylist,
                onTap: () => _openPlayer(trackList[index]),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _scrollController,
        child: scrollContent,
        builder: (context, child) {
          final scrollOffset = _scrollController.hasClients
              ? _scrollController.offset
              : 0.0;

          final double overscroll = (scrollOffset < 0.0 ? -scrollOffset : 0.0)
              .clamp(0.0, _TightScrollPhysics.maxOverscroll);

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
            coverOpacity = 1.0 - t;
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
              // 0. Заливка цветом темы при оверскролле вниз: пространство
              // над оттянутым контентом остаётся в цвет верха градиента.
              if (overscroll > 0.0)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: overscroll + topPadding + 100.0,
                  child: ColoredBox(color: gradientTop),
                ),

              // 1. Скроллируемая область: фоновый градиент и контент
              child!,

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
                      child: CoverImage(
                        url: release.coverUrl,
                        cacheSize: initialCoverSize,
                        borderRadius: ReleaseScreen.coverBorderRadius,
                        iconSize: 48.0,
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
                      child: DecoratedBox(
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
                      child: Center(
                        child: Text(
                          release.title,
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
                  onTap: () => Navigator.maybePop(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Текстовая шапка релиза: название, исполнитель, метаданные и кнопка «Слушать».
class _ReleaseHeader extends StatelessWidget {
  final Track release;

  /// Высота пустого места под плавающую обложку.
  final double coverPlaceholderHeight;

  /// Запуск воспроизведения; `null`, если в релизе нет треков.
  final VoidCallback? onPlay;

  const _ReleaseHeader({
    required this.release,
    required this.coverPlaceholderHeight,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: double.infinity, height: coverPlaceholderHeight),

        // Отступ 16 px между обложкой и названием контента
        const SizedBox(height: 16.0),

        // Название контента: максимум 2 строки с многоточием
        Text(
          release.title,
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
        const SizedBox(height: 8.0),

        Text(
          release.artist,
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
        const SizedBox(height: 8.0),

        // Метаданные релиза: тип контента, дата выхода или сохранения и длительность плейлиста
        Text(
          ReleaseFormatters.formatReleaseMetadata(release),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 16.0),

        // Кнопка воспроизведения «Слушать» на всю ширину
        SizedBox(
          width: double.infinity,
          height: 50.0,
          child: FilledButton.icon(
            onPressed: onPlay,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.textPrimary,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded, size: 24.0),
            label: const Text('Слушать'),
          ),
        ),
      ],
    );
  }
}

/// Физика скролла для экрана релиза с жестким ограничением оверскролла.
///
/// Поведение полностью идентично экрану «Главная»:
/// 1. При оттягивании вниз контент сдвигается максимум на [maxOverscroll] (14 dp)
///    с высоким сопротивлением.
/// 2. При резком взмахе (fling) вниз обложка не улетает: баллистическая скорость
///    отсекается, и тугая пружина мгновенно возвращает экран в исходное положение (0.0).
/// 3. Внизу списка скролл строго зафиксирован (поведение ClampingScrollPhysics).
class _TightScrollPhysics extends ClampingScrollPhysics {
  const _TightScrollPhysics({super.parent});

  /// Максимальный сдвиг при оттягивании вниз (в dp),
  /// точно соответствующий естественному поведению на экране «Главная».
  static const double maxOverscroll = 14.0;

  @override
  _TightScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _TightScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);

    // Внутри обычного диапазона скролла или скроллим вверх (pixels > 0 или offset < 0)
    if (position.pixels > 0.0 || (position.pixels == 0.0 && offset < 0.0)) {
      return super.applyPhysicsToUserOffset(position, offset);
    }

    // Пользователь тянет вниз у верхнего края (offset > 0 уводит pixels < 0)
    final double currentOverscroll =
        position.pixels < 0.0 ? -position.pixels : 0.0;

    // Жесткий упор: если достигнут maxOverscroll, дальнейшее движение вниз блокируется
    if (currentOverscroll >= maxOverscroll && offset > 0.0) {
      return 0.0;
    }

    // Возврат пальца вверх к 0 — свободный и отзывчивый (1:1)
    if (offset < 0.0) {
      return offset;
    }

    // Экспоненциальное упругое сопротивление при оттягивании вниз
    final double fraction = (currentOverscroll / maxOverscroll).clamp(0.0, 1.0);
    final double frictionFactor = 0.08 * math.pow(1.0 - fraction, 2.0);
    return offset * frictionFactor;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(position.minScrollExtent <= position.maxScrollExtent);

    // Снизу: поведение ClampingScrollPhysics (контент не улетает вверх за пределы списка)
    if (value > position.pixels && position.pixels >= position.maxScrollExtent) {
      return value - position.pixels;
    }
    if (value > position.maxScrollExtent &&
        position.pixels < position.maxScrollExtent) {
      return value - position.maxScrollExtent;
    }

    // Сверху: строгое ограничение максимального оттягивания maxOverscroll
    if (value < position.pixels && position.pixels <= -maxOverscroll) {
      return value - position.pixels;
    }
    if (value < -maxOverscroll && position.pixels > -maxOverscroll) {
      return value - (-maxOverscroll);
    }

    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final Tolerance tolerance = toleranceFor(position);

    // Если находимся в зоне оверскролла (pixels < 0.0)
    if (position.pixels < 0.0) {
      // Исключаем вылет обложки вниз: скорость не может быть отрицательной
      return ScrollSpringSimulation(
        const SpringDescription(
          mass: 1.0,
          stiffness: 400.0,
          damping: 30.0,
        ),
        position.pixels,
        0.0,
        math.max(0.0, velocity),
        tolerance: tolerance,
      );
    }

    // Если находимся на верхнем краю (0.0) и был резкий взмах вниз —
    // баллистический оверскролл не запускается (как на Главной)
    if (position.pixels <= 0.0 && velocity < 0.0) {
      return null;
    }

    return super.createBallisticSimulation(position, velocity);
  }
}

/// Кнопка возврата («Назад») с тактильным откликом при нажатии и удержании.
///
/// При нажатии плавно сжимается (как иконки нижней панели навигации) и затемняется
/// наложением [AppColors.pressedOverlay] (как обложки карточек на Главной),
/// сохраняя стабильную хит-зону 48x48.
class _ReleaseBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ReleaseBackButton({required this.onTap});

  static final Color _pressedColor = Color.alphaBlend(
    AppColors.pressedOverlay,
    AppColors.textPrimary,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.0,
      height: 48.0,
      child: Semantics(
        label: MaterialLocalizations.of(context).backButtonTooltip,
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
                  Icons.arrow_back_rounded,
                  size: 28.0,
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

/// Элемент списка треков на экране релиза.
class _TrackTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      builder: (context, isPressed) => AnimatedOpacity(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeInOut,
        opacity: isPressed ? 0.6 : 1.0,
        child: Row(
          children: [
            if (showCover) ...[
              SizedBox.square(
                dimension: 48.0,
                child: CoverImage(
                  url: track.coverUrl,
                  cacheSize: 48.0,
                  iconSize: 22.0,
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
                    track.title,
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
                    track.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
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
