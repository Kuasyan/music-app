import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music_app/features/player/presentation/screens/player_screen.dart';
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
      'PlayerScreen renders close arrow with 48x48 touch target and 16 top/left padding',
      (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          const MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(padding: EdgeInsets.zero),
              child: PlayerScreen(track: testTrack),
            ),
          ),
        );

        expect(find.byType(Scaffold), findsOneWidget);
        final iconFinder = find.byIcon(Icons.keyboard_arrow_down_rounded);
        expect(iconFinder, findsOneWidget);

        // Хит-зона кнопки закрытия составляет 48x48 по стандартам Google
        final buttonSizedBoxFinder = find
            .ancestor(
              of: iconFinder,
              matching: find.byType(SizedBox),
            )
            .first;
        final buttonSize = tester.getSize(buttonSizedBoxFinder);
        expect(buttonSize.width, 48.0);
        expect(buttonSize.height, 48.0);

        // Отступ от верхнего и левого края равен 16
        final buttonTopLeft = tester.getTopLeft(buttonSizedBoxFinder);
        expect(buttonTopLeft.dx, 16.0);
        expect(buttonTopLeft.dy, 16.0);

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
