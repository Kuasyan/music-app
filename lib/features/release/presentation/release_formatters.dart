import '../../../shared/models/track.dart';

/// Форматирование метаданных релиза для отображения в интерфейсе.
abstract final class ReleaseFormatters {
  /// Форматирует количество сохранений с разделителями тысяч и корректным склонением слова.
  ///
  /// Примеры: `0 сохранений`, `1 сохранение`, `2 сохранения`, `471 192 сохранения`.
  static String formatSavesCount(int count) {
    final digits = count.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }

    final mod10 = count % 10;
    final mod100 = count % 100;

    final String word;
    if (mod100 >= 11 && mod100 <= 14) {
      word = 'сохранений';
    } else if (mod10 == 1) {
      word = 'сохранение';
    } else if (mod10 >= 2 && mod10 <= 4) {
      word = 'сохранения';
    } else {
      word = 'сохранений';
    }

    return '$buffer $word';
  }

  /// Форматирует общую длительность релиза/плейлиста:
  /// - `10 ч. 45 мин.`, `1 ч. 0 мин.` (если более часа)
  /// - `42 мин.` (если менее часа и ровно минуты)
  /// - `2 мин. 32 сек.` (если менее часа с секундами)
  /// - `22 сек.` (если менее минуты)
  static String formatPlaylistDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours ч. $minutes мин.';
    } else if (minutes > 0) {
      if (seconds > 0) {
        return '$minutes мин. $seconds сек.';
      }
      return '$minutes мин.';
    } else {
      return '$seconds сек.';
    }
  }

  /// Формирует строку метаданных:
  /// - Для плейлистов: `Плейлист • <сохранения> • <длительность>`
  /// - Для альбомов и синглов: `Тип контента • Дата выхода`
  ///
  /// Отсутствующие в модели значения пропускаются, а не подменяются выдуманными.
  static String formatReleaseMetadata(Track track) {
    final parts = <String>[track.type.label];

    if (track.type == ReleaseType.playlist) {
      final savesCount = track.savesCount;
      if (savesCount != null) {
        parts.add(formatSavesCount(savesCount));
      }
      final duration = track.totalDuration ?? track.duration;
      if (duration != null) {
        parts.add(formatPlaylistDuration(duration));
      }
    } else {
      final releaseDate = track.releaseDate;
      if (releaseDate != null && releaseDate.isNotEmpty) {
        parts.add(releaseDate);
      }
    }

    return parts.join(' • ');
  }
}
