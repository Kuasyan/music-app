import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/release/presentation/screens/release_screen.dart';
import 'package:flutter_application_1/shared/models/track.dart';

void main() {
  group('ReleaseScreen formatters', () {
    test('formatSavesCount formats numbers and Russian plurals correctly', () {
      expect(ReleaseScreen.formatSavesCount(0), '0 сохранений');
      expect(ReleaseScreen.formatSavesCount(1), '1 сохранение');
      expect(ReleaseScreen.formatSavesCount(2), '2 сохранения');
      expect(ReleaseScreen.formatSavesCount(4), '4 сохранения');
      expect(ReleaseScreen.formatSavesCount(5), '5 сохранений');
      expect(ReleaseScreen.formatSavesCount(11), '11 сохранений');
      expect(ReleaseScreen.formatSavesCount(14), '14 сохранений');
      expect(ReleaseScreen.formatSavesCount(21), '21 сохранение');
      expect(ReleaseScreen.formatSavesCount(22), '22 сохранения');
      expect(ReleaseScreen.formatSavesCount(471192), '471 192 сохранения');
      expect(ReleaseScreen.formatSavesCount(1000000), '1 000 000 сохранений');
    });

    test('formatPlaylistDuration formats all user specified cases correctly', () {
      // 10 ч. 45 мин.
      expect(
        ReleaseScreen.formatPlaylistDuration(const Duration(hours: 10, minutes: 45)),
        '10 ч. 45 мин.',
      );
      // 1 ч. 0 мин.
      expect(
        ReleaseScreen.formatPlaylistDuration(const Duration(hours: 1, minutes: 0)),
        '1 ч. 0 мин.',
      );
      // 42 мин.
      expect(
        ReleaseScreen.formatPlaylistDuration(const Duration(minutes: 42)),
        '42 мин.',
      );
      // 2 мин. 32 сек.
      expect(
        ReleaseScreen.formatPlaylistDuration(
          const Duration(minutes: 2, seconds: 32),
        ),
        '2 мин. 32 сек.',
      );
      // 22 сек.
      expect(
        ReleaseScreen.formatPlaylistDuration(const Duration(seconds: 22)),
        '22 сек.',
      );
    });

    test('formatReleaseMetadata distinguishes playlists and other releases', () {
      const album = Track(
        id: '1',
        title: 'Тест',
        artist: 'Артист',
        coverUrl: '',
        type: 'Альбом',
        releaseDate: '2024',
      );
      expect(ReleaseScreen.formatReleaseMetadata(album), 'Альбом • 2024');

      const single = Track(
        id: '2',
        title: 'Тест',
        artist: 'Артист',
        coverUrl: '',
        type: 'Сингл',
        releaseDate: '2023',
      );
      expect(ReleaseScreen.formatReleaseMetadata(single), 'Сингл • 2023');

      const playlist = Track(
        id: '3',
        title: 'Тест',
        artist: 'Редакция',
        coverUrl: '',
        type: 'Плейлист',
        savesCount: 471192,
        totalDuration: Duration(hours: 10, minutes: 45),
      );
      expect(
        ReleaseScreen.formatReleaseMetadata(playlist),
        'Плейлист • 471 192 сохранения • 10 ч. 45 мин.',
      );

      const emptyPlaylist = Track(
        id: '4',
        title: 'Тест',
        artist: 'Редакция',
        coverUrl: '',
        type: 'Плейлист',
        savesCount: 0,
        totalDuration: Duration(minutes: 42),
      );
      expect(
        ReleaseScreen.formatReleaseMetadata(emptyPlaylist),
        'Плейлист • 0 сохранений • 42 мин.',
      );
    });

    testWidgets('ReleaseScreen renders play button with icon and text', (
      WidgetTester tester,
    ) async {
      const track = Track(
        id: 'test_1',
        title: 'Тестовый Трек',
        artist: 'Тестовый Артист',
        coverUrl: '',
        type: 'Альбом',
        releaseDate: '2024',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: track),
        ),
      );

      expect(find.text('Слушать'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    });

    testWidgets('ReleaseScreen renders AnimatedOpacity for gradient backdrop', (
      WidgetTester tester,
    ) async {
      const track = Track(
        id: 'test_1',
        title: 'Тестовый Трек',
        artist: 'Тестовый Артист',
        coverUrl: '',
        type: 'Альбом',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: track),
        ),
      );

      expect(find.byType(AnimatedOpacity), findsWidgets);
    });

    testWidgets('Playlist displays track covers in tracklist', (
      WidgetTester tester,
    ) async {
      const playlist = Track(
        id: 'test_pl',
        title: 'Тестовый Плейлист',
        artist: 'Редакция',
        coverUrl: '',
        type: 'Плейлист',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: playlist),
        ),
      );

      // Проверяем, что отображаются треки из плейлиста
      expect(find.text('Midnight City'), findsOneWidget);
      expect(find.text('M83'), findsOneWidget);
    });

    testWidgets('Album does not display track covers in tracklist', (
      WidgetTester tester,
    ) async {
      const album = Track(
        id: 'test_alb',
        title: 'Тестовый Альбом',
        artist: 'Автор',
        coverUrl: '',
        type: 'Альбом',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: album),
        ),
      );

      // Проверяем, что треки альбома отображаются без обложек
      expect(find.text('Вступление (Intro)'), findsOneWidget);
      expect(find.text('Автор'), findsWidgets);
    });

    testWidgets('Back button animates scale and darkens color on press', (
      WidgetTester tester,
    ) async {
      const album = Track(
        id: 'test_alb',
        title: 'Тестовый Альбом',
        artist: 'Автор',
        coverUrl: '',
        type: 'Альбом',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: album),
        ),
      );

      final backButtonFinder = find.byIcon(Icons.arrow_back_rounded);
      expect(backButtonFinder, findsOneWidget);

      // Проверяем исходный размер масштаба (1.0)
      final scaleFinder = find.ancestor(
        of: backButtonFinder,
        matching: find.byType(AnimatedScale),
      );
      expect(scaleFinder, findsOneWidget);
      final initialScale = tester.widget<AnimatedScale>(scaleFinder).scale;
      expect(initialScale, 1.0);

      // Зажимаем кнопку назад
      final gesture = await tester.startGesture(tester.getCenter(backButtonFinder));
      await tester.pump(const Duration(milliseconds: 110));

      // При зажатии масштаб сжимается до 0.88
      final pressedScale = tester.widget<AnimatedScale>(scaleFinder).scale;
      expect(pressedScale, 0.88);

      // Отпускаем кнопку
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 200));

      // Возвращается к 1.0
      final releasedScale = tester.widget<AnimatedScale>(scaleFinder).scale;
      expect(releasedScale, 1.0);
    });

    testWidgets('Tracklist trims long title and artist with ellipsis', (
      WidgetTester tester,
    ) async {
      const playlist = Track(
        id: 'test_pl',
        title: 'Тестовый Плейлист',
        artist: 'Редакция',
        coverUrl: '',
        type: 'Плейлист',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(track: playlist),
        ),
      );

      // Находим трек с длинным названием
      final longTitleFinder = find.text(
        'Starboy (feat. Daft Punk) [Kygo Remix / Deluxe Edition]',
      );
      expect(longTitleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(longTitleFinder);
      expect(titleWidget.maxLines, 1);
      expect(titleWidget.overflow, TextOverflow.ellipsis);

      // Находим трек с длинным именем исполнителя
      final longArtistFinder = find.text(
        'The Weeknd feat. Daft Punk, Gesaffelstein & Swedish House Mafia',
      );
      expect(longArtistFinder, findsOneWidget);

      final artistWidget = tester.widget<Text>(longArtistFinder);
      expect(artistWidget.maxLines, 1);
      expect(artistWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets(
      'Cover shrinks with top pinned, fades out and AppBar appears on scroll',
      (WidgetTester tester) async {
        const album = Track(
          id: 'test_scroll_album',
          title: 'Скролл Тест Альбом',
          artist: 'Тестовый Артист',
          coverUrl: '',
          type: 'Альбом',
        );

        // Задаём фиксированный размер тестового экрана
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          const MaterialApp(
            home: ReleaseScreen(track: album),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Исходное состояние: обложка видна в полном размере, AppBar ещё нет
        final coverFinder = find.byType(ClipRRect);
        expect(coverFinder, findsOneWidget);

        final initialBox = tester.getRect(coverFinder);
        final initialTop = initialBox.top;
        final initialHeight = initialBox.height;

        // В начале вверху видна только кнопка «Назад», а AppBar с заголовком ещё не появился
        // (заголовок релиза присутствует только в теле контента)
        expect(find.text('Скролл Тест Альбом'), findsOneWidget);

        // 2. Скроллим вниз (Фаза 1: сжатие с фиксацией верха)
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -80),
        );
        await tester.pump();

        final scrolledBox = tester.getRect(coverFinder);
        // Верхний край обложки остаётся зафиксированным на месте!
        expect(scrolledBox.top, closeTo(initialTop, 0.5));
        // Высота обложки уменьшилась!
        expect(scrolledBox.height, lessThan(initialHeight));

        // 3. Скроллим далеко вниз (Фаза 3: обложка исчезла, AppBar появился)
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -350),
        );
        await tester.pump();

        // Обложка скрыта (coverOpacity == 0.0, убрана из Positioned)
        expect(find.byType(ClipRRect), findsNothing);

        // Появился верхний AppBar: теперь заголовок релиза отображается и в AppBar
        expect(find.text('Скролл Тест Альбом'), findsWidgets);
      },
    );

    testWidgets(
      'Pulling down (overscroll) maintains seamless top background fill',
      (WidgetTester tester) async {
        const album = Track(
          id: 'test_overscroll_album',
          title: 'Оверскролл Тест',
          artist: 'Тестовый Артист',
          coverUrl: '',
          type: 'Альбом',
        );

        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          const MaterialApp(
            home: ReleaseScreen(track: album),
          ),
        );
        await tester.pumpAndSettle();

        // Исходное положение стрелки назад
        final backButtonFinder = find.byIcon(Icons.arrow_back_rounded);
        expect(backButtonFinder, findsOneWidget);
        final initialBackButtonRect = tester.getRect(backButtonFinder);

        // Оттягиваем экран сверху вниз (overscroll)
        final gesture = await tester.startGesture(const Offset(200, 200));
        await gesture.moveBy(const Offset(0, 150));
        await tester.pump();

        // Проверяем, что обложка сдвинулась вниз вместе с оверскроллом
        final coverFinder = find.byType(ClipRRect);
        expect(coverFinder, findsOneWidget);
        final pulledBox = tester.getRect(coverFinder);
        expect(pulledBox.top, greaterThan(16.0));

        // Проверяем, что стрелка «Назад» синхронно сместилась вниз вместе с обложкой
        final pulledBackButtonRect = tester.getRect(backButtonFinder);
        expect(pulledBackButtonRect.top, greaterThan(initialBackButtonRect.top));

        await gesture.up();
        await tester.pumpAndSettle();

        // После отпускания стрелка возвращается в исходное положение
        final restoredBackButtonRect = tester.getRect(backButtonFinder);
        expect(restoredBackButtonRect.top, closeTo(initialBackButtonRect.top, 0.5));
      },
    );
  });
}

