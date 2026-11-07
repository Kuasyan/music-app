/// Тип музыкального релиза.
enum ReleaseType {
  album('Альбом'),
  playlist('Плейлист'),
  single('Сингл');

  /// Отображаемое название на русском языке.
  final String label;
  const ReleaseType(this.label);

  /// Безопасный парсинг из строки (нечувствителен к регистру).
  static ReleaseType fromString(String value) {
    return switch (value.toLowerCase().trim()) {
      'плейлист' || 'playlist' => ReleaseType.playlist,
      'сингл' || 'single' => ReleaseType.single,
      _ => ReleaseType.album,
    };
  }
}

/// Доменная модель музыкального трека или релиза.
class Track {
  /// Уникальный идентификатор трека.
  final String id;

  /// Название трека или альбома.
  final String title;

  /// Имя исполнителя или автора подборки.
  final String artist;

  /// URL изображения обложки.
  final String coverUrl;

  /// Строковый тип релиза для удобного отображения в интерфейсе.
  final String type;

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
    this.type = 'Альбом',
    this.audioUrl,
    this.duration,
    this.releaseDate,
    this.savesCount,
    this.totalDuration,
    this.tracks,
  });

  /// Типизированное перечисление типа релиза.
  ReleaseType get releaseType => ReleaseType.fromString(type);

  /// Создание модели из Map/JSON (для интеграции с REST API или Supabase).
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverUrl: json['cover_url'] as String? ?? json['coverUrl'] as String? ?? '',
      type: json['type'] as String? ?? 'Альбом',
      audioUrl: json['audio_url'] as String? ?? json['audioUrl'] as String?,
      duration: json['duration_ms'] != null
          ? Duration(milliseconds: json['duration_ms'] as int)
          : null,
      releaseDate: json['release_date'] as String?,
      savesCount: json['saves_count'] as int?,
      totalDuration: json['total_duration_ms'] != null
          ? Duration(milliseconds: json['total_duration_ms'] as int)
          : null,
      tracks: json['tracks'] != null
          ? (json['tracks'] as List<dynamic>)
              .map((e) => Track.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  /// Преобразование модели в Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'cover_url': coverUrl,
      'type': type,
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
    String? type,
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
          tracks == other.tracks;

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
        tracks,
      );
}
