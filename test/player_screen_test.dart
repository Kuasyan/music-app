import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/features/player/presentation/screens/player_screen.dart';
import 'package:flutter_application_1/shared/models/track.dart';

void main() {
  group('PlayerScreen tests', () {
    const testTrack = Track(
      id: 'test_player_track',
      title: 'Starboy',
      artist: 'The Weeknd',
      coverUrl: '',
      type: 'Сингл',
    );

    testWidgets('PlayerScreen renders as clean empty screen', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PlayerScreen(track: testTrack),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlayerScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
