class VideoItem {
  const VideoItem({
    required this.title,
    required this.description,
    required this.url,
    required this.duration,
    required this.accentColor,
  });

  final String title;
  final String description;
  final String url;
  final String duration;
  final int accentColor;
}

const List<VideoItem> videos = [
  VideoItem(
    title: 'Big Buck Bunny',
    description: 'A bright animated short with crisp motion and sound.',
    url:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    duration: '9:56',
    accentColor: 0xFF2EC4B6,
  ),
  VideoItem(
    title: 'Sintel',
    description: 'Cinematic fantasy sample video for full-screen playback.',
    url:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    duration: '14:48',
    accentColor: 0xFFFF9F1C,
  ),
  VideoItem(
    title: 'For Bigger Blazes',
    description: 'Short action sample with strong audio presence.',
    url:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    duration: '0:15',
    accentColor: 0xFFE71D36,
  ),
  VideoItem(
    title: 'Tears of Steel',
    description: 'Sci-fi sample clip with clean streaming metadata.',
    url:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    duration: '12:14',
    accentColor: 0xFF9B5DE5,
  ),
  VideoItem(
    title: 'Elephant Dream',
    description: 'Atmospheric animation sample for testing seeking.',
    url:
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    duration: '10:53',
    accentColor: 0xFF00BBF9,
  ),
];
