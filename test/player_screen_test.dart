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

    testWidgets('PlayerScreen renders close arrow and does not render content',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PlayerScreen(track: testTrack)),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      // На текущем этапе экран пуст за исключением стрелки закрытия
      expect(find.text('Starboy'), findsNothing);
      expect(find.text('The Weeknd'), findsNothing);
    });

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
