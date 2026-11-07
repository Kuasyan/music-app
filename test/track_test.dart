import 'package:flutter_test/flutter_test.dart';

import 'package:music_app/shared/models/track.dart';

void main() {
  group('ReleaseType.fromString', () {
    test('parses machine and display names case-insensitively', () {
      expect(ReleaseType.fromString('playlist'), ReleaseType.playlist);
      expect(ReleaseType.fromString(' Плейлист '), ReleaseType.playlist);
      expect(ReleaseType.fromString('SINGLE'), ReleaseType.single);
      expect(ReleaseType.fromString('Альбом'), ReleaseType.album);
    });

    test('falls back to album for unknown or missing values', () {
      expect(ReleaseType.fromString('ep'), ReleaseType.album);
      expect(ReleaseType.fromString(null), ReleaseType.album);
    });
  });

  group('Track', () {
    test('tracks with equal nested lists are equal and share a hash code', () {
      Track build() => const Track(
            id: 'r',
            title: 'Релиз',
            artist: 'Артист',
            coverUrl: '',
            tracks: [Track(id: 't', title: 'Т', artist: 'А', coverUrl: '')],
          ).copyWith(
            // copyWith с новым списком: идентичность списков различается.
            tracks: [
              const Track(id: 't', title: 'Т', artist: 'А', coverUrl: ''),
            ],
          );

      final a = build();
      final b = build();
      expect(identical(a.tracks, b.tracks), isFalse);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('fromJson / toJson round trip', () {
      const track = Track(
        id: 'r1',
        title: 'Релиз',
        artist: 'Артист',
        coverUrl: 'https://example.com/c.jpg',
        type: ReleaseType.playlist,
        duration: Duration(seconds: 200),
        savesCount: 12,
        totalDuration: Duration(minutes: 42),
        tracks: [
          Track(id: 't1', title: 'Т', artist: 'А', coverUrl: ''),
        ],
      );

      expect(Track.fromJson(track.toJson()), track);
    });

    test('fromJson accepts numbers decoded as double', () {
      final track = Track.fromJson({
        'id': '1',
        'title': 'T',
        'artist': 'A',
        'duration_ms': 1500.0,
        'saves_count': 3.0,
      });

      expect(track.duration, const Duration(milliseconds: 1500));
      expect(track.savesCount, 3);
      expect(track.coverUrl, '');
      expect(track.type, ReleaseType.album);
    });
  });
}
