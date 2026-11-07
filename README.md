# Music App

Музыкальный стриминговый клиент на Flutter: главная лента с подборками,
экран релиза (альбом / плейлист / сингл) и заготовка полноэкранного плеера.

## Стек

- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) — состояние и DI
- [go_router](https://pub.dev/packages/go_router) — навигация (`StatefulShellRoute` для вкладок)
- [cached_network_image](https://pub.dev/packages/cached_network_image) — загрузка и кэширование обложек

## Требования

Flutter **3.47+** (Dart **3.13+**), см. `environment` в `pubspec.yaml`.

## Запуск

```bash
flutter pub get
flutter run
```

## Проверки

```bash
flutter analyze
flutter test
```

## Структура

```
lib/
  core/        роутер, тема, каркас с нижней навигацией
  features/    экраны по фичам (home, release, player, search, library, profile)
  shared/      общие модели и виджеты
```

Данные пока тестовые: `lib/features/home/data/mock_home_data.dart`.
