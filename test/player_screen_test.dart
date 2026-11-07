import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music_app/features/player/presentation/screens/player_screen.dart';
import 'package:music_app/features/release/presentation/screens/release_screen.dart';
import 'package:music_app/shared/models/track.dart';

void main() {
  group('PlayerScreen tests', () {
    const testTrack = Track(
      id: 'test_player_track',
      title: 'Starboy',
      artist: 'The Weeknd',
      coverUrl: '',
      type: ReleaseType.single,
    );

    testWidgets(
      'PlayerScreen close arrow is positioned identically to Arrow Back on ReleaseScreen',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        const simulatedPadding = EdgeInsets.only(top: 24.0);

        // 1. Измеряем координаты кнопки «Назад» на ReleaseScreen
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(padding: simulatedPadding),
              child: const ReleaseScreen(track: testTrack),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final releaseBackButtonFinder = find.byIcon(Icons.arrow_back_rounded);
        final releaseBackButtonRect = tester.getRect(
          find.ancestor(
            of: releaseBackButtonFinder,
            matching: find.byType(SizedBox),
          ).first,
        );

        // 2. Измеряем координаты кнопки закрытия на PlayerScreen
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(padding: simulatedPadding),
              child: const PlayerScreen(track: testTrack),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final playerCloseButtonFinder =
            find.byIcon(Icons.keyboard_arrow_down_rounded);
        expect(playerCloseButtonFinder, findsOneWidget);

        final playerCloseButtonRect = tester.getRect(
          find.ancestor(
            of: playerCloseButtonFinder,
            matching: find.byType(SizedBox),
          ).first,
        );

        // 3. Координаты и размеры на обоих экранах совпадают в точности до пикселя
        expect(playerCloseButtonRect.left, equals(releaseBackButtonRect.left));
        expect(playerCloseButtonRect.top, equals(releaseBackButtonRect.top));
        expect(playerCloseButtonRect.width, equals(releaseBackButtonRect.width));
        expect(playerCloseButtonRect.height, equals(releaseBackButtonRect.height));

        // Конкретные значения: left = 6.0, top = 24.0 + 4.0 = 28.0, размер = 48x48
        expect(playerCloseButtonRect.left, 6.0);
        expect(playerCloseButtonRect.top, 28.0);
        expect(playerCloseButtonRect.width, 48.0);
        expect(playerCloseButtonRect.height, 48.0);

        // На текущем этапе экран пуст за исключением стрелки закрытия
        expect(find.text('Starboy'), findsNothing);
        expect(find.text('The Weeknd'), findsNothing);
      },
    );

    testWidgets('Close button pops the player', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PlayerScreen(track: testTrack),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.byType(PlayerScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(PlayerScreen), findsNothing);
    });
  });
}
