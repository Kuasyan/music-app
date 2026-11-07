import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/data/mock_home_data.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/player/presentation/screens/player_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/release/presentation/screens/release_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../shared/models/track.dart';
import '../../shared/widgets/placeholder_screen.dart';
import '../presentation/widgets/main_shell.dart';
import 'app_routes.dart';

/// Конфигурация маршрутизации приложения.
///
/// Использует [StatefulShellRoute.indexedStack] для независимого сохранения состояния
/// и стека навигации каждой из 4 основных вкладок приложения.
///
/// Роутер создаётся внутри провайдера, а не глобальной переменной: так у каждого
/// [ProviderScope] (например, в каждом тесте) свой экземпляр с чистым состоянием,
/// и он корректно освобождается вместе со scope.
final routerProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: AppRoutes.releasePattern,
                    builder: (context, state) => _ReleaseRoute(
                      releaseId: state.pathParameters['id']!,
                      initialRelease: _trackFromExtra(state),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.player,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: PlayerScreen(track: _trackFromExtra(state)),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final tween = Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

/// `extra` не переживает deep link и восстановление состояния, а после
/// восстановления может содержать объект другого типа, поэтому прямое
/// приведение `as Track?` небезопасно.
Track? _trackFromExtra(GoRouterState state) {
  final extra = state.extra;
  return extra is Track ? extra : null;
}

/// Открывает релиз: берёт объект из `extra` для мгновенного перехода
/// или ищет релиз по идентификатору из пути (deep link, восстановление).
class _ReleaseRoute extends ConsumerWidget {
  final String releaseId;
  final Track? initialRelease;

  const _ReleaseRoute({required this.releaseId, this.initialRelease});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final release = initialRelease?.id == releaseId
        ? initialRelease
        : ref.watch(releaseByIdProvider(releaseId));

    if (release == null) {
      return const PlaceholderScreen(
        icon: Icons.album_rounded,
        title: 'Релиз не найден',
        description: 'Возможно, ссылка устарела или релиз был удалён.',
      );
    }
    return ReleaseScreen(track: release);
  }
}
