import 'package:video_player/video_player.dart';
import 'package:video/globals.dart';

Future<void> play(String url) async {
  if (url.isEmpty) return;
  if (videoPlayerController.value.isInitialized) {
    await videoPlayerController.dispose();
  }
  videoPlayerController = VideoPlayerController.network(url);
  return videoPlayerController.initialize().then(
    (value) => (videoPlayerController.play()),
  );
}
