import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';

/// Точка входа в приложение.
///
/// Настраивает системные оверлеи (Status Bar и Navigation Bar)
/// и запускает корневой виджет под управлением [ProviderScope] (Riverpod).
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      // Для iOS: светлые иконки статус-бара на тёмном фоне.
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: MusicApp()));
}

/// Корневой виджет приложения с глобальной тёмной темой и маршрутизацией [GoRouter].
class MusicApp extends ConsumerWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          surface: AppColors.background,
          primary: AppColors.textPrimary,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
