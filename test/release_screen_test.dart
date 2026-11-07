import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music_app/features/release/presentation/release_formatters.dart';
import 'package:music_app/features/release/presentation/screens/release_screen.dart';
import 'package:music_app/shared/models/track.dart';

/// Треклист для тестов: [count] треков без обложек.
List<Track> _tracks(int count, {String artist = 'Автор'}) => [
      for (var i = 1; i <= count; i++)
        Track(id: 't$i', title: 'Трек $i', artist: artist, coverUrl: ''),
    ];

void main() {
  group('ReleaseFormatters', () {
    test('formatSavesCount formats numbers and Russian plurals correctly', () {
      expect(ReleaseFormatters.formatSavesCount(0), '0 сохранений');
      expect(ReleaseFormatters.formatSavesCount(1), '1 сохранение');
      expect(ReleaseFormatters.formatSavesCount(2), '2 сохранения');
      expect(ReleaseFormatters.formatSavesCount(4), '4 сохранения');
      expect(ReleaseFormatters.formatSavesCount(5), '5 сохранений');
      expect(ReleaseFormatters.formatSavesCount(11), '11 сохранений');
      expect(ReleaseFormatters.formatSavesCount(14), '14 сохранений');
      expect(ReleaseFormatters.formatSavesCount(21), '21 сохранение');
      expect(ReleaseFormatters.formatSavesCount(22), '22 сохранения');
      expect(ReleaseFormatters.formatSavesCount(111), '111 сохранений');
      expect(ReleaseFormatters.formatSavesCount(471192), '471 192 сохранения');
      expect(
        ReleaseFormatters.formatSavesCount(1000000),
        '1 000 000 сохранений',
      );
    });

    test('formatPlaylistDuration formats all user specified cases correctly',
        () {
      expect(
        ReleaseFormatters.formatPlaylistDuration(
          const Duration(hours: 10, minutes: 45),
        ),
        '10 ч. 45 мин.',
      );
      expect(
        ReleaseFormatters.formatPlaylistDuration(const Duration(hours: 1)),
        '1 ч. 0 мин.',
      );
      expect(
        ReleaseFormatters.formatPlaylistDuration(const Duration(minutes: 42)),
        '42 мин.',
      );
      expect(
        ReleaseFormatters.formatPlaylistDuration(
          const Duration(minutes: 2, seconds: 32),
        ),
        '2 мин. 32 сек.',
      );
      expect(
        ReleaseFormatters.formatPlaylistDuration(const Duration(seconds: 22)),
        '22 сек.',
      );
    });

    test('formatReleaseMetadata distinguishes playlists and other releases',
        () {
      const album = Track(
        id: '1',
        title: 'Тест',
        artist: 'Артист',
        coverUrl: '',
        type: ReleaseType.album,
        releaseDate: '2024',
      );
      expect(ReleaseFormatters.formatReleaseMetadata(album), 'Альбом • 2024');

      const single = Track(
        id: '2',
        title: 'Тест',
        artist: 'Артист',
        coverUrl: '',
        type: ReleaseType.single,
        releaseDate: '2023',
      );
      expect(ReleaseFormatters.formatReleaseMetadata(single), 'Сингл • 2023');

      const playlist = Track(
        id: '3',
        title: 'Тест',
        artist: 'Редакция',
        coverUrl: '',
        type: ReleaseType.playlist,
        savesCount: 471192,
        totalDuration: Duration(hours: 10, minutes: 45),
      );
      expect(
        ReleaseFormatters.formatReleaseMetadata(playlist),
        'Плейлист • 471 192 сохранения • 10 ч. 45 мин.',
      );

      const emptyPlaylist = Track(
        id: '4',
        title: 'Тест',
        artist: 'Редакция',
        coverUrl: '',
        type: ReleaseType.playlist,
        savesCount: 0,
        totalDuration: Duration(minutes: 42),
      );
      expect(
        ReleaseFormatters.formatReleaseMetadata(emptyPlaylist),
        'Плейлист • 0 сохранений • 42 мин.',
      );
    });

    test('formatReleaseMetadata omits missing values instead of inventing them',
        () {
      const album = Track(id: '1', title: 'Т', artist: 'А', coverUrl: '');
      expect(ReleaseFormatters.formatReleaseMetadata(album), 'Альбом');

      const playlist = Track(
        id: '2',
        title: 'Т',
        artist: 'А',
        coverUrl: '',
        type: ReleaseType.playlist,
      );
      expect(ReleaseFormatters.formatReleaseMetadata(playlist), 'Плейлист');
    });
  });

  group('ReleaseScreen', () {
    testWidgets('renders play button with icon and text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_1',
              title: 'Тестовый Трек',
              artist: 'Тестовый Артист',
              coverUrl: '',
              releaseDate: '2024',
              tracks: _tracks(3),
            ),
          ),
        ),
      );

      expect(find.text('Слушать'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(
        tester.widget<ButtonStyleButton>(find.byType(FilledButton)).enabled,
        isTrue,
      );
    });

    testWidgets('play button is disabled for a release without tracks',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(
            track: Track(id: 'empty', title: 'Пусто', artist: 'А', coverUrl: ''),
          ),
        ),
      );

      expect(
        tester.widget<ButtonStyleButton>(find.byType(FilledButton)).enabled,
        isFalse,
      );
    });

    testWidgets('renders AnimatedOpacity for gradient backdrop', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_1',
              title: 'Тестовый Трек',
              artist: 'Тестовый Артист',
              coverUrl: '',
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedOpacity), findsWidgets);
    });

    testWidgets('playlist displays track covers in tracklist', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_pl',
              title: 'Тестовый Плейлист',
              artist: 'Редакция',
              coverUrl: '',
              type: ReleaseType.playlist,
              tracks: [
                Track(
                  id: 'pl_1',
                  title: 'Midnight City',
                  artist: 'M83',
                  coverUrl: '',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Midnight City'), findsOneWidget);
      expect(find.text('M83'), findsOneWidget);
      // Обложка релиза + обложка трека.
      expect(find.byType(ClipRRect), findsNWidgets(2));
    });

    testWidgets('album does not display track covers in tracklist',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_alb',
              title: 'Тестовый Альбом',
              artist: 'Автор',
              coverUrl: '',
              tracks: _tracks(2),
            ),
          ),
        ),
      );

      expect(find.text('Трек 1'), findsOneWidget);
      expect(find.text('Автор'), findsWidgets);
      // Только обложка самого релиза.
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('back button animates scale on press and pops the route',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ReleaseScreen(
                    track: Track(
                      id: 'test_alb',
                      title: 'Тестовый Альбом',
                      artist: 'Автор',
                      coverUrl: '',
                    ),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final backButtonFinder = find.byIcon(Icons.arrow_back_rounded);
      expect(backButtonFinder, findsOneWidget);

      final scaleFinder = find.ancestor(
        of: backButtonFinder,
        matching: find.byType(AnimatedScale),
      );
      expect(scaleFinder, findsOneWidget);
      expect(tester.widget<AnimatedScale>(scaleFinder).scale, 1.0);

      // Зажимаем кнопку назад: масштаб сжимается до 0.88
      final gesture =
          await tester.startGesture(tester.getCenter(backButtonFinder));
      await tester.pump(const Duration(milliseconds: 110));
      expect(tester.widget<AnimatedScale>(scaleFinder).scale, 0.88);

      // Отпускаем: экран закрывается без дополнительной задержки
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(ReleaseScreen), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('tracklist trims long title and artist with ellipsis',
        (tester) async {
      const longTitle = 'Starboy (feat. Daft Punk) [Kygo Remix / Deluxe Edition]';
      const longArtist =
          'The Weeknd feat. Daft Punk, Gesaffelstein & Swedish House Mafia';

      await tester.pumpWidget(
        const MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_pl',
              title: 'Тестовый Плейлист',
              artist: 'Редакция',
              coverUrl: '',
              type: ReleaseType.playlist,
              tracks: [
                Track(
                  id: 'pl_2',
                  title: longTitle,
                  artist: longArtist,
                  coverUrl: '',
                ),
              ],
            ),
          ),
        ),
      );

      final titleWidget = tester.widget<Text>(find.text(longTitle));
      expect(titleWidget.maxLines, 1);
      expect(titleWidget.overflow, TextOverflow.ellipsis);

      final artistWidget = tester.widget<Text>(find.text(longArtist));
      expect(artistWidget.maxLines, 1);
      expect(artistWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets(
      'cover shrinks with top pinned, fades out and AppBar appears on scroll',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: ReleaseScreen(
              track: Track(
                id: 'test_scroll_album',
                title: 'Скролл Тест Альбом',
                artist: 'Тестовый Артист',
                coverUrl: '',
                tracks: _tracks(30),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Исходное состояние: обложка видна в полном размере, AppBar ещё нет
        final coverFinder = find.byType(ClipRRect);
        expect(coverFinder, findsOneWidget);

        final initialBox = tester.getRect(coverFinder);
        expect(find.text('Скролл Тест Альбом'), findsOneWidget);

        // 2. Скроллим вниз (Фаза 1: сжатие с фиксацией верха)
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -80),
        );
        await tester.pump();

        final scrolledBox = tester.getRect(coverFinder);
        expect(scrolledBox.top, closeTo(initialBox.top, 0.5));
        expect(scrolledBox.height, lessThan(initialBox.height));

        // 3. Скроллим далеко вниз (Фаза 3: обложка исчезла, AppBar появился)
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -350),
        );
        await tester.pump();

        expect(find.byType(ClipRRect), findsNothing);
        // Заголовок теперь есть и в контенте, и в AppBar
        expect(find.text('Скролл Тест Альбом'), findsNWidgets(2));
      },
    );

    testWidgets('pulling down (overscroll) moves cover and back button',
        (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ReleaseScreen(
            track: Track(
              id: 'test_overscroll_album',
              title: 'Оверскролл Тест',
              artist: 'Тестовый Артист',
              coverUrl: '',
              tracks: _tracks(5),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonFinder = find.byIcon(Icons.arrow_back_rounded);
      final initialBackButtonRect = tester.getRect(backButtonFinder);
      final initialCoverRect = tester.getRect(find.byType(ClipRRect));

      // Оттягиваем экран сверху вниз (overscroll)
      final gesture = await tester.startGesture(const Offset(200, 200));
      await gesture.moveBy(const Offset(0, 150));
      await tester.pump();

      expect(
        tester.getRect(find.byType(ClipRRect)).top,
        greaterThan(initialCoverRect.top),
      );
      expect(
        tester.getRect(backButtonFinder).top,
        greaterThan(initialBackButtonRect.top),
      );

      await gesture.up();
      await tester.pumpAndSettle();

      // После отпускания стрелка возвращается в исходное положение
      expect(
        tester.getRect(backButtonFinder).top,
        closeTo(initialBackButtonRect.top, 0.5),
      );
    });
  });
}
