import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:music_app/core/router/app_router.dart';
import 'package:music_app/core/router/app_routes.dart';
import 'package:music_app/main.dart';

void main() {
  testWidgets('Smoke test: MusicApp launches and displays main navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MusicApp()));
    await tester.pump();

    expect(find.text('Главная'), findsOneWidget);
    expect(find.text('Поиск'), findsOneWidget);
    expect(find.text('Медиатека'), findsOneWidget);
    expect(find.text('Профиль'), findsOneWidget);
  });

  testWidgets('Switching tabs shows the selected tab screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MusicApp()));
    await tester.pump();

    await tester.tap(find.text('Поиск'));
    await tester.pumpAndSettle();

    expect(find.text('Поиск в разработке'), findsOneWidget);
  });

  testWidgets('Unknown release id shows a not-found screen', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MusicApp()),
    );
    container.read(routerProvider).go(AppRoutes.release('missing'));
    await tester.pumpAndSettle();

    expect(find.text('Релиз не найден'), findsOneWidget);
  });

  testWidgets('Home cards do not overflow with large system font', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const ProviderScope(child: MusicApp()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
