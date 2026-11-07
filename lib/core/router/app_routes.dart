/// Пути маршрутов приложения.
///
/// Единое место для построения адресов, чтобы строки путей не дублировались
/// по экранам и не расходились с конфигурацией роутера.
abstract final class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String player = '/player';

  /// Шаблон пути экрана релиза (вложен в [home]).
  static const String releasePattern = 'release/:id';

  /// Адрес экрана релиза с указанным идентификатором.
  static String release(String releaseId) =>
      '/release/${Uri.encodeComponent(releaseId)}';
}
