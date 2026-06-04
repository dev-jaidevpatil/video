enum MediaType { video, music }

enum MediaSource { network, asset }

class MediaItem {
  const MediaItem({
    required this.type,
    required this.title,
    required this.description,
    required this.source,
    required this.durationLabel,
    required this.accentColor,
    this.sourceType = MediaSource.network,
  });

  final MediaType type;
  final String title;
  final String description;
  final String source;
  final String durationLabel;
  final int accentColor;
  final MediaSource sourceType;

  bool get isMusic => type == MediaType.music;
}

const List<MediaItem> mediaLibrary = [
  MediaItem(
    type: MediaType.video,
    title: 'Bee Sample',
    description: 'Lightweight Flutter-hosted MP4 with browser CORS support.',
    source:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    durationLabel: 'Video',
    accentColor: 0xFF2EC4B6,
  ),
  MediaItem(
    type: MediaType.video,
    title: 'Flower Sample',
    description: 'Small MDN MP4 sample that loads quickly in web builds.',
    source: "https://youtu.be/__bHEfJ29j0?si=sAZSTEnDGkLmfEA9",
    durationLabel: 'Video',
    accentColor: 0xFFFF9F1C,
  ),
  MediaItem(
    type: MediaType.music,
    title: 'SoundHelix Song',
    description: 'MP3 music track for testing audio playback controls.',
    source: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    durationLabel: 'Music',
    accentColor: 0xFFE71D36,
  ),
];
