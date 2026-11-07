import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/track.dart';

/// Тестовые данные: персональные рекомендации для пользователя.
final recommendedTracksProvider = Provider<List<Track>>((ref) {
  return _withTracklists(const [
    Track(
      id: 'rec_1',
      type: ReleaseType.album,
      title: 'Холодный Неон (Deluxe Remastered Edition)',
      artist: 'Эрика feat. Mark Ronson & Philharmonic Orchestra',
      coverUrl: 'https://picsum.photos/seed/rec_1/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'rec_2',
      type: ReleaseType.playlist,
      title: 'Ночной Вайб & Lo-Fi: Музыка для глубокой концентрации и работы до рассвета',
      artist: 'Редакция & Chillout Community',
      coverUrl: 'https://picsum.photos/seed/rec_2/600/600',
      savesCount: 471192,
      totalDuration: Duration(hours: 10, minutes: 45),
    ),
    Track(
      id: 'rec_3',
      type: ReleaseType.single,
      title: 'Танцы в Темноте',
      artist: 'Марк Левин',
      coverUrl: 'https://picsum.photos/seed/rec_3/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'rec_4',
      type: ReleaseType.album,
      title: 'После Полуночи: Хроники Забытого Города, Часть 2',
      artist: 'The Midnight Band',
      coverUrl: 'https://picsum.photos/seed/rec_4/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'rec_5',
      type: ReleaseType.playlist,
      title: 'Электронный Драйв',
      artist: 'Sound Wave',
      coverUrl: 'https://picsum.photos/seed/rec_5/600/600',
      savesCount: 124000,
      totalDuration: Duration(hours: 1, minutes: 0),
    ),
    Track(
      id: 'rec_6',
      type: ReleaseType.single,
      title: 'Звездный Горизонт',
      artist: 'Артур Соколов',
      coverUrl: 'https://picsum.photos/seed/rec_6/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'rec_7',
      type: ReleaseType.album,
      title: 'Эхо Прошлого',
      artist: 'Polaris feat. Symphony of the Night & Alexander Rybak',
      coverUrl: 'https://picsum.photos/seed/rec_7/600/600',
      releaseDate: '2022',
    ),
    Track(
      id: 'rec_8',
      type: ReleaseType.playlist,
      title: 'Акустика и Уют',
      artist: 'Indie Coffee',
      coverUrl: 'https://picsum.photos/seed/rec_8/600/600',
      savesCount: 0,
      totalDuration: Duration(minutes: 42),
    ),
    Track(
      id: 'rec_9',
      type: ReleaseType.single,
      title: 'Без Лишних Слов',
      artist: 'Nova',
      coverUrl: 'https://picsum.photos/seed/rec_9/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'rec_10',
      type: ReleaseType.album,
      title: 'Городские Огни (Special Live Acoustic Tour 2024)',
      artist: 'Стереомир',
      coverUrl: 'https://picsum.photos/seed/rec_10/600/600',
      releaseDate: '2024',
    ),
  ]);
});

/// Тестовые данные: история недавно прослушанных треков и альбомов.
final recentlyPlayedProvider = Provider<List<Track>>((ref) {
  return _withTracklists(const [
    Track(
      id: 'recent_1',
      type: ReleaseType.single,
      title: 'Звездный Горизонт',
      artist: 'Артур Соколов',
      coverUrl: 'https://picsum.photos/seed/recent_1/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'recent_2',
      type: ReleaseType.playlist,
      title: 'Ночной Вайб & Lo-Fi: Музыка для глубокой концентрации и работы до рассвета',
      artist: 'Редакция & Chillout Community',
      coverUrl: 'https://picsum.photos/seed/recent_2/600/600',
      savesCount: 471192,
      totalDuration: Duration(hours: 10, minutes: 45),
    ),
    Track(
      id: 'recent_3',
      type: ReleaseType.album,
      title: 'Холодный Неон (Deluxe Remastered Edition)',
      artist: 'Эрика feat. Mark Ronson & Philharmonic Orchestra',
      coverUrl: 'https://picsum.photos/seed/recent_3/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'recent_4',
      type: ReleaseType.playlist,
      title: 'Midnight Drive: Synthwave & Retrowave Legends Anthology',
      artist: 'Retrowave Club & Synth Collective',
      coverUrl: 'https://picsum.photos/seed/recent_4/600/600',
      savesCount: 85300,
      totalDuration: Duration(minutes: 2, seconds: 32),
    ),
    Track(
      id: 'recent_5',
      type: ReleaseType.single,
      title: 'Акустический Вечер',
      artist: 'Indie Folk',
      coverUrl: 'https://picsum.photos/seed/recent_5/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'recent_6',
      type: ReleaseType.album,
      title: 'После Полуночи',
      artist: 'The Midnight Band',
      coverUrl: 'https://picsum.photos/seed/recent_6/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'recent_7',
      type: ReleaseType.single,
      title: 'Neon Lights',
      artist: 'Cyberdream',
      coverUrl: 'https://picsum.photos/seed/recent_7/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'recent_8',
      type: ReleaseType.single,
      title: 'Без Слов',
      artist: 'Nova',
      coverUrl: 'https://picsum.photos/seed/recent_8/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'recent_9',
      type: ReleaseType.album,
      title: 'Горизонт Событий (Симфоническая поэма в четырех актах)',
      artist: 'Space Orchestra & State Academic Choir',
      coverUrl: 'https://picsum.photos/seed/recent_9/600/600',
      releaseDate: '2021',
    ),
    Track(
      id: 'recent_10',
      type: ReleaseType.playlist,
      title: 'Утренний Кофе',
      artist: 'Morning Jazz',
      coverUrl: 'https://picsum.photos/seed/recent_10/600/600',
      savesCount: 12,
      totalDuration: Duration(seconds: 22),
    ),
  ]);
});

/// Тестовые данные: список новых музыкальных релизов.
final newReleasesProvider = Provider<List<Track>>((ref) {
  return _withTracklists(const [
    Track(
      id: 'release_1',
      type: ReleaseType.album,
      title: 'Параллельные Миры (Extended Cinematic Cut & Soundtrack)',
      artist: 'Kavinsky, Daft Punk & The Weeknd',
      coverUrl: 'https://picsum.photos/seed/release_1/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_2',
      type: ReleaseType.single,
      title: 'Не Улетай',
      artist: 'Даша Котова',
      coverUrl: 'https://picsum.photos/seed/release_2/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_3',
      type: ReleaseType.album,
      title: 'Ритм Сердца',
      artist: 'Pulse Collective',
      coverUrl: 'https://picsum.photos/seed/release_3/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_4',
      type: ReleaseType.single,
      title: 'Highway Lights: Memories of the Neon Sunset Boulevard',
      artist: 'Night Runner & Electric Youth',
      coverUrl: 'https://picsum.photos/seed/release_4/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_5',
      type: ReleaseType.album,
      title: 'Голос Ветра',
      artist: 'Северное Сияние',
      coverUrl: 'https://picsum.photos/seed/release_5/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'release_6',
      type: ReleaseType.single,
      title: 'Кибернетика',
      artist: 'Cyberpunk Project',
      coverUrl: 'https://picsum.photos/seed/release_6/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_7',
      type: ReleaseType.album,
      title: 'Вспышка Сверхновой',
      artist: 'Astro feat. Interstellar Ambient Ensemble',
      coverUrl: 'https://picsum.photos/seed/release_7/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_8',
      type: ReleaseType.single,
      title: 'До Утра',
      artist: 'DJ Alex Frost',
      coverUrl: 'https://picsum.photos/seed/release_8/600/600',
      releaseDate: '2024',
    ),
    Track(
      id: 'release_9',
      type: ReleaseType.album,
      title: 'Архитектура Звука: Эксперименты с аналоговым модульным синтезом',
      artist: 'Modular System',
      coverUrl: 'https://picsum.photos/seed/release_9/600/600',
      releaseDate: '2023',
    ),
    Track(
      id: 'release_10',
      type: ReleaseType.single,
      title: 'Искры',
      artist: 'Лия',
      coverUrl: 'https://picsum.photos/seed/release_10/600/600',
      releaseDate: '2024',
    ),
  ]);
});

/// Поиск релиза по идентификатору среди всех тестовых подборок.
///
/// Позволяет открыть экран релиза по прямой ссылке (`/release/:id`),
/// когда объект релиза не передан через `extra` маршрута.
final releaseByIdProvider = Provider.family<Track?, String>((ref, id) {
  final releases = [
    ...ref.watch(recommendedTracksProvider),
    ...ref.watch(recentlyPlayedProvider),
    ...ref.watch(newReleasesProvider),
  ];
  return releases.where((release) => release.id == id).firstOrNull;
});

/// Дополняет тестовые релизы треклистами.
List<Track> _withTracklists(List<Track> releases) {
  return [
    for (final release in releases)
      release.copyWith(tracks: _mockTracklistFor(release)),
  ];
}

/// Формирует тестовый треклист релиза с уникальными идентификаторами треков.
///
/// - Плейлист состоит из треков разных исполнителей с собственными обложками.
/// - Альбом содержит треки исполнителя релиза с обложкой альбома.
/// - Сингл состоит из одного одноимённого трека.
List<Track> _mockTracklistFor(Track release) {
  return switch (release.type) {
    ReleaseType.playlist => [
        for (final (index, (title, artist)) in _playlistTrackInfo.indexed)
          Track(
            id: '${release.id}_t${index + 1}',
            type: ReleaseType.single,
            title: title,
            artist: artist,
            coverUrl:
                'https://picsum.photos/seed/${release.id}_t${index + 1}/300/300',
          ),
      ],
    ReleaseType.album => [
        for (final (index, (title, featuring)) in _albumTrackInfo.indexed)
          Track(
            id: '${release.id}_t${index + 1}',
            type: ReleaseType.album,
            title: title,
            artist: featuring == null
                ? release.artist
                : '${release.artist} feat. $featuring',
            coverUrl: release.coverUrl,
          ),
      ],
    ReleaseType.single => [
        Track(
          id: '${release.id}_t1',
          type: ReleaseType.single,
          title: release.title,
          artist: release.artist,
          coverUrl: release.coverUrl,
        ),
      ],
  };
}

/// Названия и исполнители треков тестового плейлиста.
const _playlistTrackInfo = [
  ('Midnight City', 'M83'),
  (
    'Starboy (feat. Daft Punk) [Kygo Remix / Deluxe Edition]',
    'The Weeknd feat. Daft Punk, Gesaffelstein & Swedish House Mafia',
  ),
  ('Nightcall', 'Kavinsky & Lovefoxxx feat. Sebastian Tellier'),
  (
    'Танцы в Темноте (Special Extended Orchestral Acoustic Live Version)',
    'Марк Левин feat. Симфонический Оркестр Санкт-Петербурга',
  ),
  ('Resonance', 'HOME'),
  (
    'Холодный Неон (Club Extended VIP Mix / Instrumental Version)',
    'Эрика feat. Mark Ronson & London Contemporary Voices',
  ),
  ('Sunset Lover', 'Petit Biscuit'),
  (
    'Горизонт Событий: Путешествие сквозь Бесконечность и Время',
    'Space Orchestra & Philharmonic Electronic Ensemble',
  ),
  ('After Dark', 'Mr.Kitty'),
  (
    'Не Улетай (Slowed + Reverb Radio Edit Bonus Track)',
    'Даша Котова feat. Acoustic String Quartet & DJ Neo',
  ),
];

/// Названия треков тестового альбома и приглашённые исполнители (если есть).
const _albumTrackInfo = <(String, String?)>[
  ('Вступление (Intro)', null),
  ('Холодный Неон', null),
  (
    'Огни Большого Города и Бесконечные Неоновые Автострады (Remastered)',
    'Ночные Огни & Симфония Ветра',
  ),
  ('После Полуночи', null),
  (
    'Танцы в Темноте под Проливным Дождём (Acoustic Club Mix)',
    'Приглашённые Музыканты & Оркестр',
  ),
  ('Финал (Outro)', null),
];
