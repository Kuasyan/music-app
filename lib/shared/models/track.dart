import 'package:flutter/foundation.dart';

/// Тип музыкального релиза.
enum ReleaseType {
  album('Альбом'),
  playlist('Плейлист'),
  single('Сингл');

  /// Отображаемое название на русском языке.
  final String label;
  const ReleaseType(this.label);

  /// Безопасный парсинг из строки (нечувствителен к регистру).
  ///
  /// Принимает как машинное имя (`playlist`), так и отображаемое (`Плейлист`).
  /// Неизвестные и отсутствующие значения трактуются как [ReleaseType.album].
  static ReleaseType fromString(String? value) {
    return switch (value?.toLowerCase().trim()) {
      'плейлист' || 'playlist' => ReleaseType.playlist,
      'сингл' || 'single' => ReleaseType.single,
      _ => ReleaseType.album,
    };
  }
}

/// Доменная модель музыкального трека или релиза.
@immutable
class Track {
  /// Уникальный идентификатор трека.
  final String id;

  /// Название трека или альбома.
  final String title;

  /// Имя исполнителя или автора подборки.
  final String artist;

  /// URL изображения обложки (пустая строка, если обложки нет).
  final String coverUrl;

  /// Тип релиза.
  final ReleaseType type;

  /// Прямая ссылка на аудиопоток или файл (опционально).
  final String? audioUrl;

  /// Длительность аудиозаписи (опционально).
  final Duration? duration;

  /// Дата выхода релиза (для альбомов и синглов, например '2024').
  final String? releaseDate;

  /// Количество сохранений (для плейлистов).
  final int? savesCount;

  /// Общая длительность релиза или плейлиста.
  final Duration? totalDuration;

  /// Вложенный список треков релиза (для плейлистов и альбомов).
  final List<Track>? tracks;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    this.type = ReleaseType.album,
    this.audioUrl,
    this.duration,
    this.releaseDate,
    this.savesCount,
    this.totalDuration,
    this.tracks,
  });

  /// Создание модели из Map/JSON (для интеграции с REST API или Supabase).
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      type: ReleaseType.fromString(json['type'] as String?),
      audioUrl: json['audio_url'] as String? ?? json['audioUrl'] as String?,
      duration: _durationFromMs(json['duration_ms']),
      releaseDate: json['release_date']?.toString(),
      savesCount: (json['saves_count'] as num?)?.toInt(),
      totalDuration: _durationFromMs(json['total_duration_ms']),
      tracks: (json['tracks'] as List<dynamic>?)
          ?.map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// JSON-декодер может вернуть целое число как `double`, поэтому приводим через [num].
  static Duration? _durationFromMs(Object? value) {
    final ms = (value as num?)?.toInt();
    return ms == null ? null : Duration(milliseconds: ms);
  }

  /// Преобразование модели в Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'cover_url': coverUrl,
      'type': type.name,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (duration != null) 'duration_ms': duration!.inMilliseconds,
      if (releaseDate != null) 'release_date': releaseDate,
      if (savesCount != null) 'saves_count': savesCount,
      if (totalDuration != null)
        'total_duration_ms': totalDuration!.inMilliseconds,
      if (tracks != null) 'tracks': tracks!.map((e) => e.toJson()).toList(),
    };
  }

  /// Метод копирования с изменением отдельных полей.
  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? coverUrl,
    ReleaseType? type,
    String? audioUrl,
    Duration? duration,
    String? releaseDate,
    int? savesCount,
    Duration? totalDuration,
    List<Track>? tracks,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      coverUrl: coverUrl ?? this.coverUrl,
      type: type ?? this.type,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      releaseDate: releaseDate ?? this.releaseDate,
      savesCount: savesCount ?? this.savesCount,
      totalDuration: totalDuration ?? this.totalDuration,
      tracks: tracks ?? this.tracks,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Track &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          artist == other.artist &&
          coverUrl == other.coverUrl &&
          type == other.type &&
          audioUrl == other.audioUrl &&
          duration == other.duration &&
          releaseDate == other.releaseDate &&
          savesCount == other.savesCount &&
          totalDuration == other.totalDuration &&
          listEquals(tracks, other.tracks);

  @override
  int get hashCode => Object.hash(
        id,
        title,
        artist,
        coverUrl,
        type,
        audioUrl,
        duration,
        releaseDate,
        savesCount,
        totalDuration,
        tracks == null ? null : Object.hashAll(tracks!),
      );
}
